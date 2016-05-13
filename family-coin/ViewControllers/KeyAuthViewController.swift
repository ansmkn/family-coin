//
//  KeyAuthViewController.swift
//  family-coin
//
//  Created by Head HandH on 13/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import Foundation

class KeyAuthViewController: BaseViewController {
    
    @IBOutlet weak var nameTextField: FormTextField!
    @IBOutlet weak var keyTextField: FormTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func enterButton(sender: AnyObject) {
        guard let key = keyTextField.text where !key.isEmpty else {
            self.showMessage(nil, message: "Fill key field")
            return;
        }
        
        guard let name = nameTextField.text where !name.isEmpty else {
            self.showMessage(nil, message: "Fill name field")
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
                    let def = UserDefaultsManager()
                    def.apiKey = key
                    self.addUserWithName(name)
                }
            })

    }
    
    func addUserWithName(name: String!) {
        
        let userUrl = self.firebase.usersUrl.childByAutoId()
        
        let user = User(name: name, userId: userUrl.key)
        
        userUrl.setValue(user.attributes(), withCompletionBlock: { (error, ref) in
            if error != nil {
                self.showError(error)
            } else {
                self.performSegueWithIdentifier("START_VIEW_FORM_KEY_VIEW", sender: nil)
            }
        })
        
    }
}
