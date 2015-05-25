//
//  EmptyTableViewFormatter.swift
//  CSH News
//
//  Created by Harlan Haskins on 10/21/14.
//  Copyright (c) 2014 Haskins. All rights reserved.
//

import UIKit

extension UITableView {
    
    private struct Constants {
        static let noPostsLabel = UILabel()
    }
    
    func addLoadingTextIfNecessaryForRows(rows: UInt, withItemName name: String) {
        if (rows == 0) {
            Constants.noPostsLabel.text = "Loading \(name)..."
            Constants.noPostsLabel.font = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody), size: 18.0)
            Constants.noPostsLabel.textColor = UIColor.lightGrayColor()
            Constants.noPostsLabel.textAlignment = .Center
            Constants.noPostsLabel.sizeToFit();
            self.backgroundView = Constants.noPostsLabel;
            self.separatorStyle = .None;
        }
        else {
            self.backgroundView = nil;
            self.separatorStyle = .SingleLine;
        }
    }
}
