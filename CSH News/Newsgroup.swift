//
//  Newsgroup.swift
//  CSH News
//
//  Created by Harlan Haskins on 6/1/15.
//  Copyright (c) 2015 csh. All rights reserved.
//

import Foundation

struct Newsgroup {

    let id: Int
    let about: String?
    let maxUnreadLevel: Int?
    let name: String
    let newestPostCreationDate: NSDate
    let oldestPostCreationDate: NSDate
    let postingAllowed: Bool
    let unreadCount: Int

}
