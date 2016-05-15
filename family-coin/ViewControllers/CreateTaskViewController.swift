//
//  CreateTaskViewController.swift
//  family-coin
//
//  Created by Head HandH on 14/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import UIKit

class CreateTaskViewController: BaseViewController {
    
    var task: Task?
    private var dataSource: [UITableViewCell] = []
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
        
        self.keyboardManager = KeyboardManager(scrollView: tableView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateWishViewController.didUserTapScreen))
        self.view.addGestureRecognizer(tap)
    }
    
    func didUserTapScreen() {
        titleTextView?.resignFirstResponder()
        descriptionTextView?.resignFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = task != nil ? NSLocalizedString("Edit Task", comment: "") : NSLocalizedString("Create Task", comment: "")

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: task != nil ?  NSLocalizedString("Save", comment: ""): NSLocalizedString("Create", comment: ""), style: .Plain, target: self,
                                                                 action: #selector(CreateTaskViewController.didCreateButtonTapped(_:)))
        
        keyboardManager?.subscibeOnKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager?.unsubscribeFromKeyboardNotification()
    }
    
    var sliderCell : TaskCostEditorCell? {
        willSet {
            if sliderCell == nil {
                newValue?.slider.addTarget(self, action:#selector(CreateTaskViewController.didSliderMove(_:)) , forControlEvents: UIControlEvents.ValueChanged)
            }
        }
    }
    
    func didSliderMove(slider: UISlider) {
        sliderCell?.label.text = String(Int(slider.value))
    }
    
    var titleTextView: UITextView?
    var descriptionTextView: UITextView?
    
    func didCreateButtonTapped(button: UIBarButtonItem) {
        guard let tf = titleTextView, let tv = descriptionTextView, let sl = sliderCell?.label else {
            self.showError(nil)
            return
        }
        
        guard let cost = sl.text where !cost.isEmpty else {
            self.showError(nil)
            return
        }
        
        guard let title = tf.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) where !title.isEmpty else {
            self.showMessage(nil, message: NSLocalizedString("Title field is not filled", comment: ""))
            return
        }
        
        guard let description = tv.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) where !description.isEmpty else {
            self.showMessage(nil, message: NSLocalizedString("Description field is not filled", comment: ""))
            return
        }
        
        createTask(title, description: description, cost: cost)
        
    }

    func createTask(title: String, description: String, cost: String) {
        
        if task != nil {
            task?.title = title
            task?.description = description
            task?.cost = Int(cost)
            firebase.tasksUrl.childByAppendingPath(task!.key).setValue(task!.attributes())
        } else {
            let newTask = Task(title: title, description: description, cost: Int(cost)!, isComplete: false)
            let ref = firebase.tasksUrl.childByAutoId()
            newTask.key = ref.key
            ref.setValue(newTask.attributes())
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension CreateTaskViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(String(TaskDescriptionCell),
                                                                   forIndexPath: indexPath) as! TaskDescriptionCell
            
            cell.label.text = NSLocalizedString("Task title", comment: "")
            titleTextView = cell.textView
            if task != nil {
                cell.textView?.text = task!.title
            }
            cell.textView?.scrollEnabled = false
            cell.textView?.textContainer.maximumNumberOfLines = 1
            cell.textView?.textContainer.lineBreakMode = .ByTruncatingTail;
            cell.textView?.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(TaskDescriptionCell),
                                                                   forIndexPath: indexPath) as! TaskDescriptionCell
            cell.label.text = NSLocalizedString("Task description", comment: "")
            descriptionTextView = cell.textView

            if task != nil {
                cell.textView?.text = task!.description
            }
            cell.textView?.scrollEnabled = false
            cell.textView?.textContainer.maximumNumberOfLines = 6
            cell.textView?.delegate = self
            return cell
        default:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(String(TaskCostEditorCell),
                                                                   forIndexPath: indexPath) as! TaskCostEditorCell
            sliderCell = cell
            if task != nil {
                sliderCell?.slider.value = Float(task!.cost)
            }
            didSliderMove(cell.slider)
            return cell
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 60
        case 1:
            return 150
        default:
            return 63
        }
    }
}

extension CreateTaskViewController: UITextViewDelegate {
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


