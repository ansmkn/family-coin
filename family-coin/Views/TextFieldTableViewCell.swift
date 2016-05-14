//
//  TextFieldTableViewCell.swift
//  family-coin
//
//  Created by Sea on 14/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import UIKit
import SnapKit

class TextFieldTableViewCell: UITableViewCell {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    @IBOutlet weak var textField: UITextField!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        
    }

}
