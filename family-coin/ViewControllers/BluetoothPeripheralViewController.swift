//
//  BluetoothPeripheralViewController.swift
//  family-coin
//
//  Created by Head HandH on 14/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class BluetoothPeripheralViewController: BaseViewController {
 
    var peripheral: PeripheralBluetoothManager?
    var titleMessage: String?
    var complete: Bool = false
//    var timer: NS
    override func viewDidLoad() {
        super.viewDidLoad()
        let key = UserDefaultsManager.sharedInstance.apiKey
        self.peripheral = PeripheralBluetoothManager(dataString: key!, completition: {
            self.didFinishSendData()
        })
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints {
            $0.edges.equalTo(0)
        }
        self.activityIndicatorView.startAnimating()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.peripheral?.startAdvertising()
        titleMessage = NSLocalizedString("Please wait the device is synchronized", comment: "")
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.peripheral?.stopAdvertising()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func didFinishSendData() {
        self.complete = true
        self.peripheral?.stopAdvertising()
        self.activityIndicatorView.stopAnimating()
        titleMessage = NSLocalizedString("The data was sent, thanks", comment: "")
        self.tableView.reloadData()
    }
    
}

extension BluetoothPeripheralViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.emptyDataSetAttributedTitleString(titleMessage ?? "")
    }
    
//    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
//        return NSAttributedString.emptyDataSetAttributedDescriptionString("If you are an adult, open \"Settings\", select \"Add user\" in the app on your phone, and turn on Bluetooth on both devices")
//    }
}
