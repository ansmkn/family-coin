//
//  BluetoothViewController.swift
//  family-coin
//
//  Created by Head HandH on 14/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class BluetoothViewController: BaseViewController {
    
    var center: CenterBluetoothManager?
    var titleMessage: String?
    var descriptionMessage: String?
    var receivedData: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.center = CenterBluetoothManager(completionBlock: { (data) in
            
            self.center!.stopScan()
            if self.receivedData == nil {
                self.receivedData = data
                self.performSegueWithIdentifier("BLUETOOTH_TO_AUTH", sender: data)
            }
        })
        
        center?.didConnectBlock = {
            self.descriptionMessage = nil
            self.titleMessage = NSLocalizedString("Starting synchronization", comment: "")
            self.tableView.reloadData()
        }
        
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints {
            $0.edges.equalTo(0)
        }
        
        titleMessage = NSLocalizedString("Child, please, give the phone to an adult", comment: "")
        descriptionMessage = NSLocalizedString("If you are an adult, open \"Settings\", select \"Add user\" in the app on the other device, and turn on Bluetooth on both devices", comment: "")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "BLUETOOTH_TO_AUTH" {
            let vc = segue.destinationViewController as! KeyAuthViewController
            vc.key = sender as? String
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.emptyDataSetSource = self
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        tableView.registerNib(UINib(nibName: String(TaskCell), bundle: nil),
                              forCellReuseIdentifier: String(TaskCell))
        
        return tableView
    }()
}

extension BluetoothViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.emptyDataSetAttributedTitleString(titleMessage ?? "")
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.emptyDataSetAttributedDescriptionString(descriptionMessage ?? "")
    }
}

