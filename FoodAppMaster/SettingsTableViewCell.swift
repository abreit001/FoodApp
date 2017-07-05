//
//  SettingsTableViewCell.swift
//  LayoutTest
//
//  Created by CS User on 6/20/17.
//  Copyright © 2017 Princeton University. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var setting: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    } 
}
