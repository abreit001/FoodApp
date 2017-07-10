//
//  PublicMethods.swift
//  FoodAppMaster
//
//  Created by Abby Breitfeld on 7/5/17.
//  Copyright © 2017 Princeton University. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import os.log

class PublicMethods {
    
    //MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var sections = [String]()
    var owned = [Ingredient]()
    
    // Instance for use in other classes
    class var sharedInstance : PublicMethods {
        struct Static {
            static let instance: PublicMethods = PublicMethods()
        }
        return Static.instance
    }
    
    //MARK: Initializer
    init() {
        sections = appDelegate.sections
    }
    
    //MARK: Change Ingredient Properties
    func addToPantry(item: Ingredient) {
        // Set selected/shoppingListed
        item.shoppingListed = false
        item.selected = true
        // Set expiration date/notification date
        // item.exp = Date(timeIntervalSinceNow: item.expDuration!)
        // let notificationDuration = (item.expDuration!) * 0.7
        // item.notificationDate = Date(timeIntervalSinceNow: notificationDuration)
        
        item.exp = Date(timeIntervalSinceNow: item.expDuration!)
        let notificationDuration = 10.0
        item.notificationDate = Date(timeIntervalSinceNow: notificationDuration)
        
        print(item.notificationDate!)
        print(item.exp!)
        
        // add to owned
        owned.append(item)
        
        // create the notifcation
        NotificationList.sharedInstance.addNotification(item)
    }
    
    //MARK: Pantry Functions
    
    func loadAllIngredients() -> [[Ingredient]]? {
        var array = [[Ingredient]]()
        for _ in 0..<sections.count {
            array.append([Ingredient]())
        }
        
        for i in 0..<sections.count {
            let ArchiveURL = Ingredient.DocumentsDirectory.appendingPathComponent(sections[i])
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: ArchiveURL.path) {
                return nil
            }
            array[i] = NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL.path) as! [Ingredient]
        }
        return array
    }
    
    func loadIngredients(section: Int) -> [Ingredient]? {
        let ArchiveURL = Ingredient.DocumentsDirectory.appendingPathComponent(sections[section])
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL.path) as? [Ingredient]
    }
    
    func saveIngredients(section: Int, ingredients: [[Ingredient]]) {
        let ArchiveURL = Ingredient.DocumentsDirectory.appendingPathComponent(sections[section])
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ingredients[section], toFile: ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Pantry successfully saved.", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save pantry items...", log: OSLog.default, type: .error)
        }
    }
    
    func saveIngredients(section: Int, ingredients: [Ingredient]) {
        let ArchiveURL = Ingredient.DocumentsDirectory.appendingPathComponent(sections[section])
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ingredients, toFile: ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Pantry successfully saved.", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save pantry items...", log: OSLog.default, type: .error)
        }
    }
}
