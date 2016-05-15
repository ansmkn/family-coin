//
//  KeyAuthViewController.swift
//  family-coin
//
//  Created by Head HandH on 13/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import UIKit

class KeyAuthViewController: BaseViewController {
    var key: String?
    @IBOutlet weak var nameTextField: FormTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New user"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Complete", style: .Plain, target: self,
                                                                 action: #selector(KeyAuthViewController.enterButton(_:)))
        
        self.navigationItem.backBarButtonItem = nil
    }
    
    @IBAction func enterButton(sender: AnyObject) {
        
        guard let name = nameTextField.text where !name.isEmpty else {
            self.showMessage(nil, message: "Fill name field")
            return;
        }
        
        guard let key = key where !key.isEmpty else {
            self.showError(nil)
            self.toStartPage()
            return;
        }
        
        let ref = self.firebase.baseUrl.childByAppendingPath(key)
        self.activityIndicatorView.startAnimating()
        ref.observeSingleEventOfType(.Value, withBlock:
            { snapshot in
                if let _ = snapshot.value as? NSNull {
                    self.activityIndicatorView.stopAnimating()
                    self.showMessage(nil, message: "Key is not valid")
                } else {
                    
                    self.activityIndicatorView.stopAnimating()
                    UserDefaultsManager.sharedInstance.apiKey = key
                    self.authUser(name)
                }
            })
    }
    
    func authUser(name: String) {

        checkUser(name, completeBlock: { user in
            if user == nil {
                self.addUserWithName(name)
                return
            }
            
            if let dict = user as? [String: AnyObject] {
                UserDefaultsManager.sharedInstance.userId = dict["userId"] as? String
                UserDefaultsManager.sharedInstance.userName = dict["name"] as? String
                self.toMainViewControler()
            }
        })
    }
    
    func checkUser(userName: String, completeBlock:((AnyObject?)->())) {
        
        let usersUrl = self.firebase.usersUrl
        usersUrl.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let users = snapshot.value.allValues as? [[String: AnyObject]] {
                for value in users {
                    if let name = value["name"] as? String {
                        if userName == name {
                            completeBlock(value)
                            return
                        }
                    }
                }
                completeBlock(nil)
            } else {
                completeBlock(nil)
            }
        })
        
    }
    
    func addUserWithName(name: String!) {
        self.nameTextField.resignFirstResponder()

        let userUrl = self.firebase.usersUrl.childByAutoId()
        let user = User(name: name, userId: userUrl.key)
        
        userUrl.setValue(user.attributes(), withCompletionBlock: { (error, ref) in
            if error != nil {
                self.showError(error)
            } else {
                UserDefaultsManager.sharedInstance.userId = user.userId
                UserDefaultsManager.sharedInstance.userName = user.name
                self.toMainViewControler()
            }
        })
        
    }
    

}
