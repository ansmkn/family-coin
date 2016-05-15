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
        self.title = NSLocalizedString("Tasks", comment: "")
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
                    let task = Task(attributes: dict as! [String: AnyObject])
                    task.ref = ref.childByAppendingPath(task.key)
                    array.append(task)
                }
                self.dataSource = array
                self.tableView.reloadData()
            }
        })
    }
    
    func configureNavigationBarForClient() {
        self.firebase.userUrl?.childByAppendingPath("coins").observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                return
            }
            let coins = snapshot.value as! Int
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: String(coins) + " F", style: .Plain, target: self, action: #selector(TasksViewController.toDashboard))
            
        })
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Settings", comment: ""), style: .Plain, target: self, action: #selector(TasksViewController.toSettings))
        
    }
    
    func configureNavigationBarForAdmin() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Add", comment: ""), style: .Plain, target: self, action: #selector(TasksViewController.toTaskCreation))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Settings", comment: ""), style: .Plain, target: self, action: #selector(TasksViewController.toSettings))
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
    
    func setTask(task: Task, isComplete: Bool) {
        var value = task.attributes()
        if isClient {
            value["userName"] = UserDefaultsManager.sharedInstance.userName
            value["userId"] = UserDefaultsManager.sharedInstance.userId
        }
        value["isComplete"] = isComplete
        task.ref?.setValue(value)
    }
    
    func deleteTask(task: Task, index: Int) {
        task.ref?.removeValue()
    }
    
    func editTask(task: Task) {
        self.performSegueWithIdentifier("TASKS_TO_CREATE", sender: task)
//        task.ref?.delete(nil)
    }
    
    func acceptTask(task: Task) {
        
        let ref = firebase.usersUrl.childByAppendingPath(task.userId!)
        let cost = task.cost
        
        ref.observeSingleEventOfType(.Value, withBlock:  { snapshot in
            let user = User(attributes: snapshot.value as! [String: AnyObject])
            self.firebase.setCoins(cost + user.coins, toUserWithUserId: user.userId)
        })
        
        task.ref?.removeValue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TASKS_TO_CREATE" {
            let vc = segue.destinationViewController as! CreateTaskViewController
            vc.task = sender as? Task
        }
    }
}

extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(TaskCell), forIndexPath: indexPath) as! TaskCell
        let task = self.dataSource[indexPath.row]
        
        cell.titleLabel.text = task.title
        cell.descriptionTextView.text = task.description
        cell.costLabel.text = String(task.cost)
        
        cell.nameLabel.hidden = task.isComplete == true
        if task.isComplete == true {
            cell.statusLabel.textColor = UIColor.greenColor()
            cell.statusLabel.text = NSLocalizedString("Completed", comment: "")
            if let name = task.userName {
                cell.nameLabel.text = name
            }
        } else {
            cell.statusLabel.textColor = UIColor.grayColor()
            if let ui = task.userId where ui == UserDefaultsManager.sharedInstance.userId {
                cell.statusLabel.text = NSLocalizedString("Rejected", comment: "")
            } else {
                cell.statusLabel.text = NSLocalizedString("Pending", comment: "")
            }
        }
        
        if isClient {
            let title = task.isComplete == true ? NSLocalizedString("Reject", comment: "") : NSLocalizedString("Complete", comment: "")
            let color = task.isComplete == true ? UIColor.redColor() : UIColor.greenColor()
            let rightButton = MGSwipeButton(title: title,
                                           backgroundColor: color,
                                           callback:
                { (cell) -> Bool in
                    self.setTask(task, isComplete: !task.isComplete)
                    return true
            })
            cell.rightButtons = [rightButton]
        } else {
            if task.isComplete == true {
                cell.rightButtons = [
                    MGSwipeButton(title: NSLocalizedString("Accept", comment: ""), backgroundColor: UIColor.greenColor(), callback: { (cell) -> Bool in
                        self.acceptTask(task)
                        return true
                    }),
                    MGSwipeButton(title: NSLocalizedString("Reject", comment: ""), backgroundColor: UIColor.redColor(), callback: { (cell) -> Bool in
                        self.setTask(task, isComplete: false)
                        return true
                    })
                ]
            } else {
                cell.rightButtons = [
                    MGSwipeButton(title: NSLocalizedString("Delete", comment: ""), backgroundColor: UIColor.redColor(), callback: { (cell) -> Bool in
                        self.deleteTask(task, index: indexPath.row)
                        return true
                    }),
                    MGSwipeButton(title: NSLocalizedString("Edit", comment: ""), backgroundColor: UIColor.greenColor(), callback: { (cell) -> Bool in
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
        let task = self.dataSource[indexPath.row]
        print(task.attributes())
    }
    
}


extension TasksViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.emptyDataSetAttributedTitleString(NSLocalizedString("Empty data", comment: ""))
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.emptyDataSetAttributedDescriptionString(NSLocalizedString("There are no tasks yet", comment: ""))
    }
}

