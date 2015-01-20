//
//  AuthenticationManager.swift
//  CSH News
//
//  Created by Harlan Haskins on 11/26/14.
//  Copyright (c) 2014 csh. All rights reserved.
//

import Foundation
import KeychainWrapper

class AuthenticationManager: NSObject {
    
    private struct Constants {
        static let credentials = AuthenticationManager.loadCredentials()!
        static let clientID = Constants.credentials.clientID
        static let clientSecret = Constants.credentials.clientSecret
        static let oAuthURL = NetworkManager.baseURL + "oauth"
        static let authorizationURL = Constants.oAuthURL + "authorize"
        static let tokenURL = Constants.oAuthURL + "token"
        static let redirectURL = NSURL(string: "cshnews://callback")!
        static let tokenKey = "edu.rit.csh.News.OAuthTokenKey"
    }
    
    class func loadCredentials() -> (clientID: String, clientSecret: String)? {
        if let fileURL = NSBundle.mainBundle().pathForResource("credentials", ofType: "txt") {
            var error: NSError?
            let credentialString = NSString(data: NSFileManager.defaultManager().contentsAtPath(fileURL)!, encoding: NSUTF8StringEncoding)!
            if let error = error {
                println(error.localizedDescription)
            } else {
                let components = credentialString.componentsSeparatedByString("\n") as [String]
                return (clientID: components.first!, clientSecret: components.last!)
            }
        }
        return nil
    }
    
    class var token: String? {
        return KeychainWrapper.stringForKey(Constants.tokenKey)
    }
    
    class func requestAccess(completion: (OAuthSwiftCredential?, NSError?) -> Void) {
        Async.background {
            let oauth = OAuth2Swift(
                consumerKey:    Constants.clientID,
                consumerSecret: Constants.clientSecret,
                authorizeUrl:   Constants.authorizationURL.absoluteString!,
                accessTokenUrl: Constants.tokenURL.absoluteString!,
                responseType:   "token"
            )
            oauth.authorizeWithCallbackURL(
                Constants.redirectURL, scope: "",
                state: "", params: [:],
                success: { credential, response in
                    self.saveCredentials(credential)
                    completion(credential, nil)
                },
                failure: { error in
                    completion(nil, error)
                }
            )
        }
    }
    
    class func saveCredentials(credential: OAuthSwiftCredential) {
        KeychainWrapper.setString(credential.oauth_token, forKey: Constants.tokenKey)
    }
}

func +(lhs: NSURL, rhs: String) -> NSURL {
    return lhs.URLByAppendingPathComponent(rhs)
}
