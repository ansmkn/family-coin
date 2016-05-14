//
//  UsersViewController.swift
//  family-coin
//
//  Created by Head HandH on 14/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class UsersViewController: BaseViewController {
    
    var dataSource: [User] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        tableView.registerClass(UserTableViewCell.self, forCellReuseIdentifier: String(UserTableViewCell))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users"
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints {
            $0.edges.equalTo(0)
        }
        
        self.activityIndicatorView.startAnimating()
        self.firebase.usersUrl.observeEventType(.Value, withBlock: { snapshot in
            self.activityIndicatorView.stopAnimating()
            if let users = snapshot.value as? NSDictionary {
                var array: [User] = []
                for dict in users.allValues {
                    let user = User(attributes: dict as! [String: AnyObject])
                    array.append(user)
                }
                self.dataSource = array
                self.tableView.reloadData()
            }
        })
    }
    
}

extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(String(UserTableViewCell), forIndexPath: indexPath)
        
        let user = self.dataSource[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = String(user.coins)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension UsersViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.emptyDataSetAttributedTitleString("Empty data")
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.emptyDataSetAttributedDescriptionString("There are no users yet")
    }
}