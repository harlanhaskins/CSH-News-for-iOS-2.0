//
//  PostsViewController.swift
//  CSH News
//
//  Created by Harlan Haskins on 11/24/14.
//  Copyright (c) 2014 csh. All rights reserved.
//

import UIKit

class PostsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AuthenticationManager.sharedManager.oauth2.authorizeEmbeddedWith(self, params: nil, autoDismiss: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows: UInt = 0
        tableView.addLoadingTextIfNecessaryForRows(rows, withItemName: "Posts")
        return Int(rows)
    }
    
}
