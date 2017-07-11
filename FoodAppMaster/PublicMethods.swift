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
    var no = [Ingredient]()
    
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
        
    }
    
    func addRestriction(restriction: String) {
        
        
        
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
        
        let length = useMe.count
        
        if length < 5 {
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
        
        // create the notifcation
        NotificationList.sharedInstance.addNotification(item)
    }
    
    func clearUseMe() {
        
        useMe = [Ingredient]()
    }
    
    func deleteFromQuery(name: String) {
        
        // DELETE FROM USEME
        
        if isInUseMe(name: name) {
        
        var count = -1
        var indexFirst = -1
        for thing in useMe {
          count = count + 1
            if thing.name == name {
                 indexFirst = count
            }
        }
        
        if useMe.count > 1 {
            useMe.remove(at: indexFirst)
        } else {
            useMe = [Ingredient]()
        }
        }
        
        // DELETE FROM OWNED
        var count2 = -1
        var index2 = -1
        for thing in owned {
            count2 = count2 + 1
            if thing.name == name {
                index2 = count2
            }
        }
        if owned.count > 1  {
            owned.remove(at: index2)
        } else {
            owned = [Ingredient]()
        }
        
        
    // REPLACE IF NEEDED
        var count3 = -1
        var index = 0
        var minDate = Date(timeIntervalSinceReferenceDate: 9999999999999999999999999.0)
        for thing in owned {
            count3 = count3 + 1
            if thing.exp! < minDate && !(isInUseMe(name: thing.name)) {
                minDate = thing.exp!
                index = count3
            }
        }
        if (owned.count > 0 && count3 >= 0) && !isInUseMe(name: owned[index].name) {
            useMe.append(owned[index])
        }
        
        // SAVE AND UPDATE QUERY
        saveUseMe()
        
        print("deleting")
        for thing in useMe {
            
            print(thing.name)
        }
    }
    
    func isInUseMe(name: String) -> Bool {
        
        var contained = false
        
        for item in useMe {
            if item.name == name {
                contained = true
            }
            
        }
       print("item is contained: ", contained)
        return contained
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
