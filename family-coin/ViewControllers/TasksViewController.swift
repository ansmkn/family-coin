//
//  TasksViewController.swift
//  family-coin
//
//  Created by Head HandH on 14/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class TasksViewController: BaseViewController {
    
    private var dataSource: [UITableViewCell] = []
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        tableView.registerClass(TaskTableViewCell.self, forCellReuseIdentifier: String(TaskTableViewCell))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tasks"
        if UserDefaultsManager().isClient == true {
            self.configureNavigationBarForClient()
        } else {
            self.configureNavigationBarForAdmin()
        }
        
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints {
            $0.edges.equalTo(0)
        }
    }
    
    func configureNavigationBarForClient() {
        self.firebase.userUrl?.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                return
            }
            let coins = snapshot.value["coins"] as! Int
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: String(coins) + " F", style: .Plain, target: self, action: #selector(TasksViewController.toDashboard))
            
        })
        
    }
    
    func configureNavigationBarForAdmin() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: #selector(TasksViewController.toTaskCreation))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: #selector(TasksViewController.toSettings))
    }
    
    func toDashboard() {
        self.performSegueWithIdentifier("TASKS_TO_DASHBOARD", sender: nil)
    }
    
    func toTaskCreation() {
        self.performSegueWithIdentifier("TASKS_TO_CREATE", sender: nil)
    }
    
    func toSettings() {
        self.performSegueWithIdentifier("TASKS_TO_SETTINGS", sender: nil)
    }
    
    func toTask(index: Int) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(TaskTableViewCell), forIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}


extension TasksViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.emptyDataSetAttributedTitleString("Empty data")
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.emptyDataSetAttributedDescriptionString("There are no tasks yet")
    }
}
