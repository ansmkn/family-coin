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
        self.title = NSLocalizedString("Login", comment: "")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .Plain, target: self,
                                                                 action: #selector(LoginViewController.didTappedLoginButton(_:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.didUserTapScreen))
        self.view.addGestureRecognizer(tap)
    }
    
    func didUserTapScreen() {
        self.passwordTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
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
            self.showMessage(nil, message: NSLocalizedString("Empty fields", comment: ""))
        }
    }
    
    func resign() {
        self.passwordTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
    }
    
    func loginUser(email: String!, password: String!) {
        self.resign()
        self.activityIndicatorView.startAnimating()
        self.firebase.baseUrl.authUser(email, password: password, withCompletionBlock: { (error, data) in
            if error != nil {
                self.activityIndicatorView.stopAnimating()
                self.showError(error)
            } else {
                self.prepareUserData(data.uid, email: email)
            }
            //
        })
    }

    func prepareUserData(id: String, email: String) {
        self.userDefaults.apiKey = id
        self.firebase.homeUrl.childByAppendingPath("email").setValue(email, withCompletionBlock: { (error, data) in
            self.activityIndicatorView.stopAnimating()
            if error != nil {
                self.showError(error)
            } else {
                self.toMainViewControler()
            }
        })
        
    }

    
}
