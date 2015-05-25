//
//  URIManager.swift
//  CSH News
//
//  Created by Harlan Haskins on 11/26/14.
//  Copyright (c) 2014 csh. All rights reserved.
//

import Foundation
import OAuthSwift

class URIManager: NSObject {
   
   private struct Constants {
      static let baseURIScheme = NSURL(string: "cshnews://")!
   }
   
   class func URIScheme() -> NSURL {
      return Constants.baseURIScheme
   }
   
   class func handleURL(url: NSURL) {
      var query: [String: String]?
      if let parameters = url.query {
         query = self.parseQueryString(parameters)
      } else {
         query = [String: String]()
      }
      if let host = url.host {
         switch host {
         case "callback":
            OAuth2Swift.handleOpenURL(url)
            break
         default: break
         }
      }
   }
   
   class func parseQueryString(string: String) -> [String: String] {
      var query = [String: String]()
      let components = string.componentsSeparatedByString("&")
      for pair in components {
         let parameters = pair.componentsSeparatedByString("=")
         let key = parameters.first!.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
         let value = parameters.last!.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
         query[key] = value
      }
      return query
   }
}
