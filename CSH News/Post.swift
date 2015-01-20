//
//  Post.swift
//  CSH News
//
//  Created by Harlan Haskins on 11/26/14.
//  Copyright (c) 2014 csh. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Author {
    let name: String
    let email: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
    
    init?(json: JSON) {
        let name = json["name"]
        let email = json["email"]
        if name == nil || email == nil {
            return nil
        }
        self.init(name: name.string!, email: email.string!)
    }
}

class Post: Printable {
    let author: Author
    let body: String
    let newsgroup: String
    let subject: String
    
    convenience init?(json: JSON) {
        let author = Author(json: json["author"])!
        let body = json["body"].string!
        let subject = json["subject"].string!
        let newsgroup = json["newsgroup"].string!
        self.init(author: author, body: body, newsgroup: newsgroup, subject: subject)
    }
    
    convenience init(name: String, email: String, body: String, newsgroup: String, subject: String) {
        let author = Author(name: name, email: email)
        self.init(author: author, body: body, newsgroup: newsgroup, subject: subject)
    }
    
    init(author: Author, body: String, newsgroup: String, subject: String) {
        self.author = author
        self.body = body
        self.newsgroup = newsgroup
        self.subject = subject
    }
    
    var description: String {
        return "\(self.author.name): \(self.subject) - \(self.body)"
    }
}
