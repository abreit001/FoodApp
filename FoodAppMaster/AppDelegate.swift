//
//  AppDelegate.swift
//  FoodAppMaster
//
//  Created by Abby Breitfeld on 6/16/17.
//  Copyright © 2017 Princeton University. All rights reserved.
//

import UIKit
import UserNotifications
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let sections = ["Dairy", "Meat", "Vegetables", "Fruits", "Fish and Seafood", "Baking and Grains", "Spices and Seasonings", "Nuts and Seeds", "Legumes", "Condiments and Sauces", "Desserts and Snacks", "Soup", "Beverages and Alcohol"]
    var ingredients = [[Ingredient]]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Initialize ingredients array
        for _ in 0..<sections.count {
            ingredients.append([Ingredient]())
        }
        
        // Load any saved items, otherwise load sample data.
        if let saved = PublicMethods.sharedInstance.loadAllIngredients() {
            print("Found saved data")
            self.ingredients = saved
        }
        else {
            // Load the sample data.
            print("Did not find saved data")
            loadInitialData()
            for i in 0..<sections.count {
                PublicMethods.sharedInstance.saveIngredients(section: i, ingredients: ingredients)
            }
        }
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        // let notificationItems: [Ingredient] = NotificationList.sharedInstance.allItems() // retrieve list of all to-do items
        // UIApplication.shared.applicationIconBadgeNumber = notificationItems.count // set our badge number to number of overdue items
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    /*func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }*/
    
    
    //MARK: Private Methods
    
    private func loadInitialData() {
        for i in 0..<sections.count {
            let fileName = sections[i]
            let fileUrl = Bundle.main.url(forResource: fileName, withExtension: ".txt")
            let foodList = try! String (contentsOf: fileUrl!, encoding: String.Encoding.utf8)
            let foods = foodList.components(separatedBy:.newlines)
            for food in foods {
                if (food != "") {
                    guard let item = Ingredient(name: food, expDuration: 30) else {
                        fatalError("Unable to instantiate item")
                    }
                    ingredients[i].append(item)
                }
            }
        }
    }
    
    /*
    private func loadIngredients() -> [[Ingredient]]? {
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
    
    private func savePantry(section: Int) {
        let ArchiveURL = Ingredient.DocumentsDirectory.appendingPathComponent(sections[section])
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ingredients[section], toFile: ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Pantry successfully saved.", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save pantry items...", log: OSLog.default, type: .error)
        }
    }*/

}


