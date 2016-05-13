//
// Created by Head HandH on 13/05/16.
// Copyright (c) 2016 Sea. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let userDefaults = UserDefaultsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTappedLoginButton(sender: AnyObject) {
        if let email = emailTextField.text,
            let password = passwordTextField.text
            where !email.isEmpty && !password.isEmpty {
            
            self.loginUser(email, password: password)
            
        } else {
            self.showMessage(nil, message: "Empty fields")
        }
    }
    
    func loginUser(email: String!, password: String!) {
        self.activityIndicatorView.startAnimating()
        self.firebase.baseUrl.authUser(email, password: password, withCompletionBlock: { (error, data) in
            self.activityIndicatorView.stopAnimating()
            if error != nil {
                self.showError(error)
            } else {
                self.userDefaults.apiKey = data.uid
                self.userDefaults.isClient = false
                self.toMainViewController()
            }
            //
        })
    }

    func toMainViewController() {
        
        self.performSegueWithIdentifier("start-segue", sender: nil)
    }
    
}
