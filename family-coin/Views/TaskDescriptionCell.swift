//
//  TaskDescriptionCell.swift
//  family-coin
//
//  Created by Head HandH on 14/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import SnapKit
import UIKit

class TaskDescriptionCell: UITableViewCell {

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textView: UITextView!

    
}
