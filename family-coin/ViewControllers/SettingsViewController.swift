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
    
    let isClient: Bool
    required init(coder: NSCoder){
        self.isClient = UserDefaultsManager.sharedInstance.isClient
        super.init(coder: coder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints {
            $0.edges.equalTo(0)
        }
        
        
        dataSource.append({
            let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            cell.textLabel?.text = "Logout"
            return cell
            }())
        if !isClient {
            
            dataSource.append({
                let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.textLabel?.text = "Users"
                return cell
                }())
            
            dataSource.append({
                let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.textLabel?.text = "Wishes"
                return cell
                }())
            
            dataSource.append({
                let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.textLabel?.text = "Add user"
                return cell
                }())
        }
        
        
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
        switch indexPath.row {
        case 0:
            UserDefaultsManager.sharedInstance.resetDefaults()
            self.toStartPage()
        case 1:
            self.performSegueWithIdentifier("SETTINGS_TO_USERS", sender: nil)
        case 2:
            self.performSegueWithIdentifier("SETTINGS_TO_WISHES", sender: nil)
        default:
            self.performSegueWithIdentifier("TO_PERIPHERAL", sender: nil)
        }
        
    }
}
