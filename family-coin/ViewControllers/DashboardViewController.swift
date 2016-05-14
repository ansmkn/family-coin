//
//  DashboardViewController.swift
//  family-coin
//
//  Created by Head HandH on 14/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import UIKit

class DashboardViewController: BaseViewController {
    
    var userId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Wish list"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if userId == nil {
            userId = UserDefaultsManager.sharedInstance.userId
        }
    }
    
    
    
}
