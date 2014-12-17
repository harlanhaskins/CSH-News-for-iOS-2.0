//
//  NetworkManager.swift
//  CSH News
//
//  Created by Harlan Haskins on 11/26/14.
//  Copyright (c) 2014 csh. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkErrorCode: Int {
   case NoAccount = 1
   case Serialization = 2
   case NoData = 3
   
   func error(userInfo: [String: AnyObject]? = nil) -> NSError {
      return NSError(domain: "edu.rit.csh.News", code: self.rawValue, userInfo: userInfo)
   }
}

class NetworkManager: NSObject {

   private struct Constants {
      static let baseURL = NSURL(string: "https://webnews-dev.csh.rit.edu")!
      static let sharedManager = NetworkManager()
   }
   
   class var baseURL: NSURL {
      return Constants.baseURL
   }
   
   class var sharedManager: NetworkManager {
      return Constants.sharedManager
   }
   
   func loadPosts(completion: ([Post]?, NSError?) -> Void) {
      let postsURL = Constants.baseURL.URLByAppendingPathComponent("posts")
      let parameters = ["as_threads": true]
      self.loadRequest(.GET, url: postsURL, parameters: parameters) { posts, error in
         println(posts)
         println(error)
         completion(nil, nil)
      }
   }
   
   func loadRequest(method: Alamofire.Method, url: URLStringConvertible, parameters: [String: AnyObject]?, completion: (AnyObject?, NSError?) -> Void) {
      if AuthenticationManager.token == nil {
         completion(nil, NetworkErrorCode.NoAccount.error(userInfo: nil))
         return
      }
      
      // Creating an Instance of the Alamofire Manager
      var manager = Manager.sharedInstance
      
      // Specifying the Headers we need
      manager.session.configuration.HTTPAdditionalHeaders = [
         "Content-Type": "application/json",
         "Accept": "application/vnd.csh.webnews.v1+json",
         "Authorization": "Bearer \(AuthenticationManager.token!)"
      ]
      
      manager.request(method, url, parameters: parameters, encoding: .JSON)
             .responseJSON { request, response, json, error in
               println(response)
                completion(json, error)
             }
   }
   
}
