//
//  RegisterViewController.swift
//  family-coin
//
//  Created by Head HandH on 13/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//
import UIKit

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var rPasswordTextField: FormTextField!
    @IBOutlet weak var passwordTextField: FormTextField!
    @IBOutlet weak var emailTextField: FormTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func didTappedRegisterButton(sender: AnyObject) {
        
        if let email = emailTextField.text,
            let password = passwordTextField.text,
            let rPassword = rPasswordTextField.text
            where !email.isEmpty && !password.isEmpty && !rPassword.isEmpty {
            
            
            guard password == rPassword else {
                self.showMessage(nil, message: "Passwords do not match")
                return
            }
            
            self.registerUser(email, password: password)
            
        } else {
            self.showMessage(nil, message: "Empty fields")
        }
        
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func registerUser(email: String!, password: String!) {

        self.activityIndicatorView.startAnimating()
        self.firebase.baseUrl.createUser(email, password: password, withCompletionBlock: { error in
            self.activityIndicatorView.stopAnimating()
            if error != nil {
                self.showError(error)
            } else {
                self.dissmisViewController(email, password:password)
            }
        })
    }

    func dissmisViewController(email: String!, password: String!) {

        //TODO: Rewrite, this terrible method
        let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
        let viewController = appDelegate.window!.rootViewController as! LoginViewController
        viewController.passwordTextField.text = password
        viewController.emailTextField.text = email
        self.backButton(self)

    }

}
