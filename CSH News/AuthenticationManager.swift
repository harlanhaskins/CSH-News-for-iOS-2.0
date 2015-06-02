//
//  AuthenticationManager.swift
//  CSH News
//
//  Created by Harlan Haskins on 11/26/14.
//  Copyright (c) 2014 csh. All rights reserved.
//

import Foundation
import p2_OAuth2
import Async

class AuthenticationManager: NSObject {
    
    private struct Constants {
        static let credentials = AuthenticationManager.loadCredentials()!
        static let clientID = Constants.credentials.clientID
        static let clientSecret = Constants.credentials.clientSecret
        static let baseURL = NSURL(string: "https://webnews-staging.csh.rit.edu")!
        static let oAuthURL = Constants.baseURL + "oauth"
        static let authorizationURL = Constants.oAuthURL + "authorize"
        static let tokenURL = Constants.oAuthURL + "token"
        static let redirectURL = "cshnews://callback"
        static let tokenKey = "edu.rit.csh.News.OAuthTokenKey"
        static let sharedManager = AuthenticationManager()
    }
    
    class var sharedManager: AuthenticationManager {
        return Constants.sharedManager
    }
    
    
    let oauth2 = OAuth2CodeGrant(settings: [
        "client_id": Constants.credentials.clientID,
        "client_secret": Constants.credentials.clientSecret,
        "authorize_uri": Constants.authorizationURL.absoluteString!,
        "token_uri": Constants.tokenURL.absoluteString!,
        "redirect_uris": [Constants.redirectURL],
        "verbose": true
    ])
    
    func handleURL(url: NSURL) {
        self.oauth2.handleRedirectURL(url)
    }
    
    class func loadCredentials() -> (clientID: String, clientSecret: String)? {
        if let fileURL = NSBundle.mainBundle().pathForResource("credentials", ofType: "txt") {
            var error: NSError?
            let credentialString = NSString(data: NSFileManager.defaultManager().contentsAtPath(fileURL)!, encoding: NSUTF8StringEncoding)!
            if let error = error {
                println(error.localizedDescription)
            } else {
                let components = credentialString.componentsSeparatedByString("\n") as! [String]
                return (clientID: components.first!, clientSecret: components.last!)
            }
        }
        return nil
    }
    
    func requestAccess(completion: NSError? -> Void) {
        Async.background {
            self.oauth2.afterAuthorizeOrFailure = { wasFailure, error in
                completion(error)
            }
            self.oauth2.authorize()
        }
    }
    
}

func +(lhs: NSURL, rhs: String) -> NSURL {
    return lhs.URLByAppendingPathComponent(rhs)
}
