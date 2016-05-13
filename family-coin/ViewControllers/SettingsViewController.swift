//
//  SettingsViewController.swift
//  family-coin
//
//  Created by Head HandH on 14/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
    
    private var dataSource: [UITableViewCell] = []
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: String(UITableViewCell))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints {
            $0.edges.equalTo(0)
        }
//        
//        array.append({
//            let cell = AboutMFCTitleAddressCell(style: .Default, reuseIdentifier: nil)
//            cell.titleLabel.text = mfcModel.name
//            cell.addressLabel.text = mfcModel.cntAddress
//            return cell
//            }())
        
        dataSource.append({
            let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            cell.textLabel?.text = "Logout"
            return cell
            }())
        
        dataSource.append({
            let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.textLabel?.text = "Users"
            return cell
            }())
        
        
        self.tableView.reloadData()
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.dataSource[indexPath.row]

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 1 {
            self.performSegueWithIdentifier("SETTINGS_TO_USERS", sender: nil)
        }
    }
}
