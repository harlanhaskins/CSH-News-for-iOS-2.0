//
//  User.swift
//  CSH News
//
//  Created by Harlan Haskins on 5/20/15.
//  Copyright (c) 2015 csh. All rights reserved.
//

import Foundation

struct User {
    let username: String
    let email: String
    let displayName: String
    let creationDate: NSDate
    let isAdmin: Bool
    
    static func userFromJSON(json: NSDictionary) -> User? {
        if let
            username = json["username"] as? String,
            displayName = json["display_name"] as? String,
            email = json["email"] as? String,
            creationDateString = json["created_at"] as? String,
            creationDate = DateFormatter.sharedFormatter.dateFromISO8601String(creationDateString),
            isAdmin = json["is_admin"] as? Bool {
                return User(username: username, email: email, displayName: displayName, creationDate: creationDate, isAdmin: isAdmin)
        }
        return nil
    }
}