//
//  TasksViewController.swift
//  family-coin
//
//  Created by Head HandH on 14/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import MGSwipeTableCell

class TasksViewController: BaseViewController {
    
    private var dataSource: [Task] = []
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        tableView.registerNib(UINib(nibName: String(TaskCell), bundle: nil),
                              forCellReuseIdentifier: String(TaskCell))
        
        return tableView
    }()
    
    let isClient: Bool
    required init(coder: NSCoder){
        self.isClient = UserDefaultsManager.sharedInstance.isClient
        super.init(coder: coder)!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tasks"
        if isClient {
            self.configureNavigationBarForClient()
        } else {
            self.configureNavigationBarForAdmin()
        }
        
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints {
            $0.edges.equalTo(0)
        }
        
        let ref = firebase.tasksUrl
        activityIndicatorView.startAnimating()
        ref.observeEventType(.Value, withBlock: { snapshot in
            self.activityIndicatorView.stopAnimating()
            if snapshot.value is NSNull {
                self.dataSource = []
                self.tableView.reloadData()
                return
            }
            
            if let tasks = snapshot.value as? NSDictionary {
                var array: [Task] = []
                for dict in tasks.allValues {
                    let user = Task(attributes: dict as! [String: AnyObject])
                    user.ref = ref.childByAppendingPath(user.key)
                    array.append(user)
                }
                self.dataSource = array
                self.tableView.reloadData()
            }
        })
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
    
    func setTask(task: Task, isComplete: Bool) {
        if isClient {
            var value: [String: AnyObject] = [:]
            value["isComplete"] = isComplete
            value["userName"] = UserDefaultsManager.sharedInstance.userName
            value["userId"] = UserDefaultsManager.sharedInstance.userId
            
            task.ref?.setValue(value)
        } else {
            task.ref?.setValue(["isComplete": isComplete])
        }
    }
    
    func deleteTask(task: Task, index: Int) {
        task.ref?.removeValue()
        
//        task.
    }
    
    func editTask(task: Task) {
        
//        task.ref?.delete(nil)
    }
    
    func acceptTask(task: Task) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(TaskCell), forIndexPath: indexPath) as! TaskCell
        let task = self.dataSource[indexPath.row]
        
        cell.titleLabel.text = task.title
        cell.descriptionTextView.text = task.description
        
        
        if isClient {
            cell.rightButtons = [
                MGSwipeButton(title: task.isComplete ? "Eject" : "Complete", backgroundColor: UIColor.greenColor(), callback: { (cell) -> Bool in
                    self.setTask(task, isComplete: !task.isComplete)
                    return true
                })
            ]
        } else {
            if task.isComplete {
                cell.rightButtons = [
                    MGSwipeButton(title: "Accept", backgroundColor: UIColor.greenColor(), callback: { (cell) -> Bool in
                        self.acceptTask(task)
                        return true
                    }),
                    MGSwipeButton(title: "Eject", backgroundColor: UIColor.redColor(), callback: { (cell) -> Bool in
                        self.setTask(task, isComplete: false)
                        return true
                    })
                ]
            } else {
                cell.rightButtons = [
                    MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(), callback: { (cell) -> Bool in
                        self.deleteTask(task, index: indexPath.row)
                        return true
                    }),
                    MGSwipeButton(title: "Edit", backgroundColor: UIColor.greenColor(), callback: { (cell) -> Bool in
                        self.editTask(task)
                        return true
                    })
                ]
            }
        }
        
        cell.leftSwipeSettings.transition = MGSwipeTransition.Drag
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let task = self.dataSource[indexPath.row]
        print(task.attributes())
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

