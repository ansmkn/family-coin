//
//  DashboardViewController.swift
//  family-coin
//
//  Created by Head HandH on 14/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import MGSwipeTableCell

class DashboardViewController: BaseViewController {
    
    let isClient: Bool
    required init(coder: NSCoder){
        self.isClient = UserDefaultsManager.sharedInstance.isClient
        super.init(coder: coder)!
    }
    
    private var dataSource: [Wish] = []
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints {
            $0.edges.equalTo(0)
        }
        
        self.activityIndicatorView.startAnimating()
        let ref = firebase.wishesUrl
        ref.observeEventType(.Value, withBlock: { snapshot in
            self.activityIndicatorView.stopAnimating()
            if snapshot.value is NSNull {
                self.dataSource = []
                self.tableView.reloadData()
                return
            }
            
            if let wishes = snapshot.value as? NSDictionary {
                var array: [Wish] = []
                for dict in wishes.allValues {
                    let wish = Wish(attributes: dict as! [String: AnyObject])
                    wish.ref? = ref.childByAppendingPath(wish.uiid)
                    if self.isClient == true {
                        if wish.userId == UserDefaultsManager.sharedInstance.userId {
                            array.append(wish)
                        }
                    } else {
                        array.append(wish)
                    }
                }
                self.dataSource = array
                self.tableView.reloadData()
            }
            
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.title = NSLocalizedString("Wish list", comment: "")
        if isClient {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self,
                                                                     action: #selector(DashboardViewController.openCreateWish))
        } else {
            self.title = NSLocalizedString("Users' wishes", comment: "")
        }
    }
    
    func openCreateWish() {
        self.performSegueWithIdentifier("CREATE_WISH", sender: nil)
    }
    
    var costLabel: UILabel?
    func showCostAlert(forWish wish: Wish)  {
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let margin:CGFloat = 8.0
        let rect = CGRectMake(margin, margin, alertController.view.bounds.size.width - margin * 4.0, 63)
        let customView = UIView(frame: rect)
        
        let label = UILabel()
        customView.addSubview(label)
        label.text = "10"
        label.snp_makeConstraints {
            make in
            make.centerY.equalTo(0)
            make.right.equalTo(-20)
            make.width.equalTo(30)
        }
        
        costLabel = label
        
        let slider = UISlider()
        slider.maximumValue = 100
        slider.minimumValue = 0
        slider.value = 10
        customView.addSubview(slider)
        slider.snp_makeConstraints {
            make in
            make.left.equalTo(20)
            make.centerY.equalTo(0)
            make.right.equalTo(label.snp_left).offset(-8)
        }
        
        slider.addTarget(self, action:#selector(DashboardViewController.didSliderMove(_:)) , forControlEvents: UIControlEvents.ValueChanged)
        
        customView.backgroundColor = UIColor.clearColor()
        alertController.view.addSubview(customView)
        
        let somethingAction = UIAlertAction(title: NSLocalizedString("Rate", comment: ""), style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in
            self.setCostOnWish(wish)
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion:{})
    }
    
    func setCostOnWish(wish: Wish) {
        let cost = Int(costLabel!.text!)
        wish.cost = cost
        firebase.wishesUrl.childByAppendingPath(wish.uiid).setValue(wish.attributes())
    }
    
    func setAccept(wish: Wish) {
        
    }
    
    func setRemoveWish(wish: Wish) {
        firebase.wishesUrl.childByAppendingPath(wish.uiid).removeValue()
    }
    
    func setBuyWish(wish: Wish) {
        let ref = firebase.usersUrl.childByAppendingPath(UserDefaultsManager.sharedInstance.userId).childByAppendingPath("coins")
        ref?.observeSingleEventOfType(.Value, withBlock: {snapshot in
            let cost = snapshot.value as! Int
            if cost > wish.cost! {
                let newCost = cost - wish.cost!
                ref?.setValue(newCost)
                
                self.setRemoveWish(wish)
            } else {
                self.showMessage(nil, message: NSLocalizedString("You have not enough coins", comment: ""))
            }
        })
    }
    
    func didSliderMove(slider: UISlider) {
        costLabel?.text = String(Int(slider.value))
    }

}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(TaskCell), forIndexPath: indexPath) as! TaskCell
        let wish = self.dataSource[indexPath.row]
        
        cell.titleLabel.text = wish.title
        cell.descriptionTextView.text = wish.description
        
        if let cost = wish.cost {
            cell.costLabel.text = String(cost)
            cell.costLabel.hidden = false
        } else {
            cell.costLabel.hidden = true
        }
        
        cell.nameLabel.text = wish.userName
        
        if isClient == true {
            
            cell.nameLabel.hidden = true
            if wish.cost != nil {
                cell.statusLabel.textColor = UIColor.greenColor()
                cell.statusLabel.text = NSLocalizedString("Priced", comment: "")
                cell.rightButtons = [
                    MGSwipeButton(title: NSLocalizedString("Delete", comment: ""), backgroundColor: UIColor.redColor(), callback: { (cell) -> Bool in
                        self.setRemoveWish(wish)
                        return true
                    }),
                    MGSwipeButton(title: NSLocalizedString("Buy", comment: ""), backgroundColor: UIColor.greenColor(), callback: { (cell) -> Bool in
                        self.setBuyWish(wish)
                        return true
                    })
                ]
            } else {
                cell.statusLabel.textColor = UIColor.grayColor()
                cell.statusLabel.text = NSLocalizedString("Pending", comment: "")
                cell.rightButtons = [
                    MGSwipeButton(title: NSLocalizedString("Delete", comment: ""), backgroundColor: UIColor.redColor(), callback: { (cell) -> Bool in
                        self.setRemoveWish(wish)
                        return true
                    })
                ]
            }
            
        } else {
            cell.nameLabel.hidden = false
            cell.statusLabel.textColor = UIColor.greenColor()
            if wish.cost != nil {
                cell.statusLabel.textColor = UIColor.grayColor()
                cell.statusLabel.text = NSLocalizedString("Pending", comment: "")
            } else {
                cell.statusLabel.textColor = UIColor.grayColor()
                cell.statusLabel.text = NSLocalizedString("Pending", comment: "")
                
            }
            
            if wish.isConfirm == false {
                if wish.cost != nil {
                    cell.statusLabel.textColor = UIColor.greenColor()
                    cell.statusLabel.text = NSLocalizedString("Priced", comment: "")
                } else {
                    cell.statusLabel.textColor = UIColor.grayColor()
                    cell.statusLabel.text = NSLocalizedString("Pending", comment: "")
                }
                cell.rightButtons = [
                    MGSwipeButton(title: NSLocalizedString("Rate", comment: ""), backgroundColor: UIColor.greenColor(), callback: { (cell) -> Bool in
                        self.showCostAlert(forWish: wish)
                        return true
                    })
                ]
            } else {
                cell.statusLabel.textColor = UIColor.greenColor()
                cell.statusLabel.text = NSLocalizedString("Want buy", comment: "")
                cell.rightButtons = [
                    MGSwipeButton(title: NSLocalizedString("Accept", comment: ""), backgroundColor: UIColor.greenColor(), callback: { (cell) -> Bool in
                        self.setAccept(wish)
                        return true
                    })
                ]
            }
        }
        
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


extension DashboardViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.emptyDataSetAttributedTitleString(NSLocalizedString("Empty data", comment: ""))
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.emptyDataSetAttributedDescriptionString(NSLocalizedString("There are no whishes yet", comment: ""))
    }
}