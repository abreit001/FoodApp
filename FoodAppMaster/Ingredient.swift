//
//  Ingredient.swift
//  LayoutTest
//
//  Created by Abby Breitfeld on 6/19/17.
//  Copyright © 2017 Princeton University. All rights reserved.
//

import UIKit
import os.log

class Ingredient: NSObject, NSCoding {
    
    //MARK: Properties
    // FUCK CARL'S COMMENT
    var name: String
    var selected: Bool
    var shoppingListed: Bool
    var expDuration: TimeInterval?
    var exp: Date?
    var notificationDate: Date?
    
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let selected = "selected"
        static let shoppingListed = "shoppingListed"
        static let expDuration = "expDuration"
        static let exp = "exp"
        static let notificationDate = "notificationDate"
    }
    
    //MARK: Initialization
    
    init?(name: String, expDuration: TimeInterval) {
        // Initialize stored properties.
        self.name = name
        self.selected = false
        self.shoppingListed = false
        self.expDuration = expDuration
        self.exp = Date(timeIntervalSinceReferenceDate: 0)
        self.notificationDate = Date(timeIntervalSinceReferenceDate: 0)
    }
    
    init?(name: String, selected: Bool, shoppingListed: Bool, expDuration: TimeInterval, exp: Date?, notificationDate: Date?) {
        // Initialize stored properties.
        self.name = name
        self.selected = selected
        self.shoppingListed = shoppingListed
        self.expDuration = expDuration
        self.exp = exp
        self.notificationDate = notificationDate
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(selected, forKey: PropertyKey.selected)
        aCoder.encode(shoppingListed, forKey: PropertyKey.shoppingListed)
        aCoder.encode(expDuration, forKey: PropertyKey.expDuration)
        aCoder.encode(exp, forKey: PropertyKey.exp)
        aCoder.encode(notificationDate, forKey: PropertyKey.notificationDate)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.name) as! String
        let selected = aDecoder.decodeBool(forKey: PropertyKey.selected)
        let shoppingListed = aDecoder.decodeBool(forKey: PropertyKey.shoppingListed)
        let expDuration = aDecoder.decodeObject(forKey: PropertyKey.expDuration) as? TimeInterval
        let exp = aDecoder.decodeObject(forKey: PropertyKey.exp) as? Date
        let notificationDate = aDecoder.decodeObject(forKey: PropertyKey.notificationDate) as? Date
        // Must call designated initializer.
        self.init(name: name, selected: selected, shoppingListed: shoppingListed, expDuration: expDuration!, exp: exp, notificationDate: notificationDate)
    }

}
