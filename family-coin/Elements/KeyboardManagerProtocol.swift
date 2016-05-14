//
//  KeyboardManagerProtocol.swift
//  family-coin
//
//  Created by Head HandH on 14/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import UIKit

class KeyboardManager {
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    let scrollView: UIScrollView
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
    }
    
    func subscibeOnKeyboardNotification() {
        notificationCenter.addObserver(self, selector: #selector(KeyboardManager.keyboardWillShow(_:)),
                                       name: UIKeyboardDidShowNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(KeyboardManager.keyboardWillHide(_:)),
                                       name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification() {
        notificationCenter.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let rect = (notification.userInfo!)[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        let backupInset = scrollView.contentInset
        scrollView.contentInset = UIEdgeInsets(top: backupInset.top, left: backupInset.left, bottom: backupInset.bottom + rect.size.height, right: backupInset.right)
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let rect = (notification.userInfo!)[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        let backupInset = scrollView.contentInset
        scrollView.contentInset = UIEdgeInsets(top: backupInset.top, left: backupInset.left, bottom: backupInset.bottom - rect.size.height, right: backupInset.right)
    }
}