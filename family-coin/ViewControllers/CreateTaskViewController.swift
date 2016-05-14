//
//  CreateTaskViewController.swift
//  family-coin
//
//  Created by Head HandH on 14/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import UIKit

class CreateTaskViewController: BaseViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Task"
        
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints {
            $0.edges.equalTo(0)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .Plain, target: self,
                                                                 action: #selector(CreateTaskViewController.didCreateButtonTapped(_:)))
        
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
    
    var textField: UITextField?
    var textView: UITextView?
    
    func didCreateButtonTapped(button: UIBarButtonItem) {
        guard let tf = textField, let tv = textView, let sl = sliderCell?.label else {
            self.showError(nil)
            return
        }
        
        guard let cost = sl.text where !cost.isEmpty else {
            self.showError(nil)
            return
        }
        
        guard let title = tf.text where !title.isEmpty else {
            self.showMessage(nil, message: "Title field is not filled")
            return
        }
        
        guard let description = tv.text where !description.isEmpty else {
            self.showMessage(nil, message: "Description field is not filled")
            return
        }
        
        createTask(title, description: description, cost: cost)
        
    }
    
    func createTask(title: String, description: String, cost: String) {
        let task = Task(title: title, description: description, cost: Int(cost)!, isComplete: false)
        
        let ref = firebase.tasksUrl.childByAutoId()
        task.ref = ref
        ref.setValue(task.attributes())
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension CreateTaskViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(String(TextFieldTableViewCell),
                                                                   forIndexPath: indexPath) as! TextFieldTableViewCell
            
            cell.textField.placeholder = "Title";
            textField = cell.textField
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(TaskDescriptionCell),
                                                                   forIndexPath: indexPath) as! TaskDescriptionCell
            cell.label.text = "Task description"
            textView = cell.textView
            return cell
        default:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(String(TaskCostEditorCell),
                                                                   forIndexPath: indexPath) as! TaskCostEditorCell
            sliderCell = cell
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
            return 56
        case 1:
            return 150
        default:
            return 63
        }
    }
}
