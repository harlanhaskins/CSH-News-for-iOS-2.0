//
//  Array+Functional.swift
//  CSH News
//
//  Created by Harlan Haskins on 5/20/15.
//  Copyright (c) 2015 csh. All rights reserved.
//

import Foundation

func mapMaybe<T, U>(array: [T], transform: (T -> U?)) -> [U] {
    var result = [U]()
    for element in array {
        if let transformed = transform(element) {
            result.append(transformed)
        }
    }
    return result
}