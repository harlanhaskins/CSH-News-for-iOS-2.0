//
//  Post.swift
//  CSH News
//
//  Created by Harlan Haskins on 11/26/14.
//  Copyright (c) 2014 csh. All rights reserved.
//

import Foundation

struct Stickiness {
    let username: String
    let displayName: String
    let expirationDate: NSDate
}

struct Author {
    let name: String
    let email: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
    
    static func authorFromJSON(json: NSDictionary) -> Author? {
        if let
            name = json["name"] as? String,
            email = json["email"] as? String {
                return Author(name: name, email: email)
        }
        return nil
    }
}

enum PersonalLevel: Int {
    case None
    case InThread
    case Reply
    case Mine
}

struct Post: Printable {
    let author: Author
    let id: Int
    let ancestorIDs: [Int]
    let body: String
    let creationDate: NSDate
    let followupNewsgroupID: Int?
    let hadAttachments: Bool
    let isDethreaded: Bool
    let isStarred: Bool
    let messageID: String
    let newsgroupIDs: [Int]
    let personalLevel: PersonalLevel
    let subject: String
    let stars: Int
    let unreadClass: String?
    let stickiness: Stickiness?
    
    static func postFromJSON(json: NSDictionary) -> Post? {
        if let
            authorDict = json["author"] as? NSDictionary,
            author = Author.authorFromJSON(authorDict),
            body = json["body"] as? String,
            id = json["id"] as? Int,
            ancestorIDs = json["ancestor_ids"] as? [Int],
            creationDateString = json["created_at"] as? String,
            creationDate = DateFormatter.sharedFormatter.dateFromISO8601String(creationDateString),
            hadAttachments = json["had_attachments"] as? Bool,
            isDethreaded = json["is_dethreaded"] as? Bool,
            isStarred = json["is_starred"] as? Bool,
            messageID = json["message_id"] as? String,
            newsgroupIDs = json["newsgroup_ids"] as? [Int],
            personalLevelInt = json["personal_level"] as? Int,
            personalLevel = PersonalLevel(rawValue: personalLevelInt),
            stars = json["total_stars"] as? Int,
            subject = json["subject"] as? String {
                
                let unreadClass = json["unread_class"] as? String
                let followupNewsgroupID = json["followup_newsgroup_id"] as? Int
                let stickiness: Stickiness? = {
                    if let
                        stickinessDict = json["sticky"] as? [String: String],
                        username = stickinessDict["username"],
                        displayName = stickinessDict["display_name"],
                        expirationString = stickinessDict["created_at"],
                        expirationDate = DateFormatter.sharedFormatter.dateFromISO8601String(expirationString) {
                            return Stickiness(username: username, displayName: displayName, expirationDate: expirationDate)
                    }
                    return nil
                }()
                return Post(author: author, id: id, ancestorIDs: ancestorIDs, body: body, creationDate: creationDate, followupNewsgroupID: followupNewsgroupID, hadAttachments: hadAttachments, isDethreaded: isDethreaded, isStarred: isStarred, messageID: messageID, newsgroupIDs: newsgroupIDs, personalLevel: personalLevel, subject: subject, stars: stars, unreadClass: unreadClass, stickiness: stickiness)
        }
        return nil
    }
    
    var description: String {
        return "\(self.author.name): \(self.subject) - ID: \(self.id)"
    }
}
