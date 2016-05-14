//
//  TaskTableViewCell.swift
//  family-coin
//
//  Created by Head HandH on 14/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class TaskTableViewCell: MGSwipeTableCell {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
}
