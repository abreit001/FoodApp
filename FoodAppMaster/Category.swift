//
//  Category.swift
//  LayoutTest
//
//  Created by Abby Breitfeld on 6/16/17.
//  Copyright © 2017 Princeton University. All rights reserved.
//

import UIKit

class Category {
    
    //MARK: Properties
    
    var name: String
    var icon: UIImage
    
    //MARK: Initialization
    
    init?(name: String, icon: UIImage) {
        // Initialize stored properties.
        self.name = name
        self.icon = icon
    }
}
