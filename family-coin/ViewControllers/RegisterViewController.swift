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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Register", comment: ""), style: .Plain, target: self,
                                                                 action: #selector(RegisterViewController.didTappedRegisterButton(_:)))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.didUserTapScreen))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
    }

    func didUserTapScreen() {
        self.resign()
    }
    
    @IBAction func didTappedRegisterButton(sender: AnyObject) {
        
        if let email = emailTextField.text,
            let password = passwordTextField.text,
            let rPassword = rPasswordTextField.text
            where !email.isEmpty && !password.isEmpty && !rPassword.isEmpty {
            
            
            guard password == rPassword else {
                self.showMessage(nil, message: NSLocalizedString("Passwords do not match", comment: ""))
                return
            }
            self.didUserTapScreen()
            self.registerUser(email, password: password)
            
        } else {
            self.showMessage(nil, message: NSLocalizedString("Empty fields", comment: ""))
        }
    }
    
    func resign() {
        self.rPasswordTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
    }
    
    func registerUser(email: String!, password: String!) {
        self.resign()
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
        let vcs = self.navigationController!.viewControllers
        let lvc = vcs[vcs.count - 2] as! LoginViewController
        
        lvc.emailTextField.text = email
        lvc.passwordTextField.text = password
        self.navigationController?.popViewControllerAnimated(true)

    }

}
