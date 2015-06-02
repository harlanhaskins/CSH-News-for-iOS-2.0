//
//  NewsAPI.swift
//  CSH News
//
//  Created by Harlan Haskins on 11/26/14.
//  Copyright (c) 2014 csh. All rights reserved.
//

import Foundation
import Dollar
import p2_OAuth2

enum NetworkErrorCode: Int {
   case NoAccount = 1
   case Serialization = 2
   case NoData = 3
   
   func error(userInfo: [String: AnyObject]? = nil) -> NSError {
      return NSError(domain: "edu.rit.csh.News", code: self.rawValue, userInfo: userInfo)
   }
}


class NewsAPI: AFHTTPSessionManager {
   
   private struct Constants {
      static let sharedManager = NewsAPI()
      static let baseURL = "https://webnews-staging.csh.rit.edu"
   }
   
   class var sharedManager: NewsAPI {
      return Constants.sharedManager
   }
   
   convenience init() {
      self.init(baseURL: NSURL(string: Constants.baseURL))
      let responseSerializer = AFJSONResponseSerializer()
      responseSerializer.removesKeysWithNullValues = true
      self.responseSerializer = responseSerializer
   }
   
   func loadUserData(completion: (User?, NSError?) -> Void) {
      self.GET("user", parameters: nil, success: { task, data in
         if let
            dictionary = data as? [String: AnyObject],
            userDict = dictionary["user"] as? NSDictionary,
            user = User.userFromJSON(userDict) {
               completion(user, nil)
         } else {
            completion(nil, NetworkErrorCode.Serialization.error(userInfo: nil))
         }
      }) { task, error in
         completion(nil, error)
      }
   }
   
   func loadPosts(completion: ([Post]?, NSError?) -> Void) {
      let parameters = ["as_threads": true]
      self.GET("posts", parameters: parameters, success: { task, data in
         if let
            mainDict = data as? NSDictionary,
            postDictionaries = mainDict["descendants"] as? [NSDictionary] {
            let posts = mapMaybe(postDictionaries, Post.postFromJSON)
            completion(posts, nil)
         } else {
            completion(nil, NetworkErrorCode.Serialization.error(userInfo: nil))
         }
      }) { task, error in
         completion(nil, error)
      }
   }
   
   override func dataTaskWithRequest(request: NSURLRequest!, completionHandler: ((NSURLResponse!, AnyObject!, NSError!) -> Void)!) -> NSURLSessionDataTask! {
      
      let newRequest = AuthenticationManager.sharedManager.oauth2.request(forURL: request.URL!)
      newRequest.HTTPBody = request.HTTPBody
      return super.dataTaskWithRequest(newRequest, completionHandler: completionHandler)
   }
}
