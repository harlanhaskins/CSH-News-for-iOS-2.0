//
//  Post.swift
//  CSH News
//
//  Created by Harlan Haskins on 11/26/14.
//  Copyright (c) 2014 csh. All rights reserved.
//

import Foundation

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

struct Post: Printable {
    let author: Author
    let body: String
    let subject: String
    
    static func postFromJSON(json: NSDictionary) -> Post? {
        if let
            authorDict = json["author"] as? NSDictionary,
            author = Author.authorFromJSON(authorDict),
            body = json["body"] as? String,
            subject = json["subject"] as? String {
                return Post(author: author, body: body, subject: subject)
        }
        return nil
    }
    
    var description: String {
        return "\(self.author.name): \(self.subject) - \(self.body)"
    }
}
