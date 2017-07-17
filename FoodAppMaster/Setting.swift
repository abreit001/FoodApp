//
//  Setting.swift
//  LayoutTest
//
//  Created by CS User on 6/22/17.
//  Copyright © 2017 Princeton University. All rights reserved.
//

import UIKit
import os.log

class Setting: NSObject, NSCoding
{
    // MARK: Properties
    
    var setting: String
    var isOn: Bool
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("settings")
    
    // MARK: Types
    
    struct PropertyKey {
        static let setting = "setting"
        static let isOn = "isOn"
    }
    
    // MARK: Initialization
    
    init?(setting: String, isOn: Bool)
    {
        // Initialize stored properties
        self.setting = setting
        self.isOn = isOn
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(setting, forKey: PropertyKey.setting)
        aCoder.encode(isOn, forKey: PropertyKey.isOn)
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let setting = aDecoder.decodeObject(forKey: PropertyKey.setting) as? String
        let isOn = aDecoder.decodeBool(forKey: PropertyKey.isOn)
        
        self.init(setting: setting!, isOn: isOn)
    }
}
