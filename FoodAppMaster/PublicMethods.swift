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
    var useMe = [Ingredient]()
    var query = ""
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = PublicMethods.DocumentsDirectory.appendingPathComponent("useMe")
    
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
        if let saved = loadUseMe() {
           useMe = saved
        }
        else {
            saveUseMe()
        }
        
        query = ""
        for thing in useMe {
            query.append(thing.name)
            query.append(", ")
        }
    }
    
    //MARK: Change Ingredient Properties
    func addToPantry(item: Ingredient) {
        // Set selected/shoppingListed
        item.shoppingListed = false
        item.selected = true
        // Set expiration date/notification date
        item.exp = Date(timeIntervalSinceNow: item.expDuration!)
        let notificationDuration = (item.expDuration!) * 0.7
        item.notificationDate = Date(timeIntervalSinceNow: notificationDuration)
        
        // add to owned
        owned.append(item)
        
        let length = useMe.count
        
        if length < 1 {
            
            useMe.append(item)
        } else {
        var count = -1
        var index = -1
        var minDate = item.exp
        for thing in useMe {
            count = count + 1
            if minDate! < thing.exp! {
                minDate = thing.exp!
                index = count
            }
        }
            if index >= 0 {
               useMe[index] = item
            }
        }
        saveUseMe()
        query = ""
        for thing in useMe {
            query.append(thing.name)
            query.append(", ")
        }
        
        // create the notifcation
        NotificationList.sharedInstance.addNotification(item)
    }
    
    func deleteFromQuery(name: String) {
        
        var count = -1
        for thing in useMe {
          count = count + 1
            if thing.name == name {
                print("count ", count)
                useMe.remove(at: count)
            }
        }
        
        var count2 = -1
        var index = 0
        var minDate = Date(timeIntervalSinceReferenceDate: 999999999999999999.0)
        for thing in owned {
            count2 = count2 + 1
            if thing.exp! < minDate{
                minDate = thing.exp!
                index = count2
            }
        }
        if owned.count > 0 {
            useMe.append(owned[index])
        }
        
        saveUseMe()
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
    
    func saveUseMe() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(useMe, toFile: PublicMethods.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("useMe successfully saved.", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save useMe...", log: OSLog.default, type: .error)
        }
        
    }
    
    func loadUseMe() -> [Ingredient]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: PublicMethods.ArchiveURL.path) as? [Ingredient]
    }
    
}
