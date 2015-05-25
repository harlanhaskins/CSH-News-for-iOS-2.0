//
//  DateFormatter.swift
//  CSH News
//
//  Created by Harlan Haskins on 5/20/15.
//  Copyright (c) 2015 csh. All rights reserved.
//

import Foundation

class DateFormatter: NSObject {
    
    private struct Constants {
        static let sharedFormatter = DateFormatter()
    }
    
    private let dateFormatter = NSDateFormatter()
    
    class var sharedFormatter: DateFormatter {
        return Constants.sharedFormatter
    }
    
    func dateFromISO8601String(string: String) -> NSDate? {
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return self.dateFormatter.dateFromString(string)
    }
    
    func stringFromDate(date: NSDate, format: String = "yyyy-MM-dd") -> String {
        self.dateFormatter.dateFormat = format
        return self.dateFormatter.stringFromDate(date)
    }

}
