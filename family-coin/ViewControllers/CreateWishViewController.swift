//
//  CreateWishViewController.swift
//  family-coin
//
//  Created by Head HandH on 15/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import UIKit
class CreateWishViewController: BaseViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "TableViewCells", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: String(TextFieldTableViewCell))
        tableView.registerNib(UINib(nibName: String(TaskDescriptionCell), bundle: nil), forCellReuseIdentifier: String(TaskDescriptionCell))
        tableView.registerNib(UINib(nibName: String(TaskCostEditorCell), bundle: nil), forCellReuseIdentifier: String(TaskCostEditorCell))
        return tableView
    }()
    
    var keyboardManager: KeyboardManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints {
            $0.edges.equalTo(0)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateWishViewController.didUserTapScreen))
        self.view.addGestureRecognizer(tap)
    }
    
    func didUserTapScreen() {
        titleTextView?.resignFirstResponder()
        descriptionTextView?.resignFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Create Wish"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .Plain, target: self,
                                                                 action: #selector(CreateWishViewController.didCreateButtonTapped(_:)))
        
        keyboardManager?.subscibeOnKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager?.unsubscribeFromKeyboardNotification()
    }

    
    var titleTextView: UITextView?
    var descriptionTextView: UITextView?
    
    func didCreateButtonTapped(button: UIBarButtonItem) {
        guard let tf = titleTextView, let tv = descriptionTextView else {
            self.showError(nil)
            return
        }
        
        guard let title = tf.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) where !title.isEmpty else {
            self.showMessage(nil, message: "Title field is not filled")
            return
        }
        
        guard let description = tv.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) where !description.isEmpty else {
            self.showMessage(nil, message: "Description field is not filled")
            return
        }
        
        createWish(title, description: description)
        
    }
    
    func createWish(title: String, description: String) {
        let ref = firebase.wishesUrl.childByAutoId()
        let uiid = ref.key
        let userId = UserDefaultsManager.sharedInstance.userId
        let userName = UserDefaultsManager.sharedInstance.userName
        let newWish = Wish(uiid: uiid, title: title, description: description, userId: userId!, userName: userName!)
        ref.setValue(newWish.attributes())
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension CreateWishViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(String(TaskDescriptionCell),
                                                                   forIndexPath: indexPath) as! TaskDescriptionCell
            
            cell.label.text = "Wish title"
            titleTextView = cell.textView
            cell.textView?.scrollEnabled = false
            cell.textView?.textContainer.maximumNumberOfLines = 1
            cell.textView?.textContainer.lineBreakMode = .ByTruncatingTail;
            cell.textView?.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(TaskDescriptionCell),
                                                                   forIndexPath: indexPath) as! TaskDescriptionCell
            cell.label.text = "Wish description"
            descriptionTextView = cell.textView
            
            cell.textView?.scrollEnabled = false
            cell.textView?.textContainer.maximumNumberOfLines = 6
            cell.textView?.delegate = self
            return cell
            
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 60
        default:
            return 150
        }
    }
}

extension CreateWishViewController: UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if textView == titleTextView {
            if text == "\n" {
                descriptionTextView?.becomeFirstResponder()
                return false
            }
        }
        return true
        //
    }
    
}


