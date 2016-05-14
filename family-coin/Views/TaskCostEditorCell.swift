//
//  TaskCostEditorCell.swift
//  family-coin
//
//  Created by Head HandH on 14/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import UIKit

class TaskCostEditorCell: UITableViewCell {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    @IBOutlet weak var slider: UISlider!

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
