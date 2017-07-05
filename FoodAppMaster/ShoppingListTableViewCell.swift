//
//  ShoppingListTableViewCell.swift
//  LayoutTest
//
//  Created by Abby Breitfeld on 6/21/17.
//  Copyright © 2017 Princeton University. All rights reserved.
//

import UIKit

class ShoppingListTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var item: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
