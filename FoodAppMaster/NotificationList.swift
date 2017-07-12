//
//  NotificationList.swift
//  FoodApp
//
//  Created by CS User on 6/28/17.
//  Copyright © 2017 Princeton University. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationList {
    
    // I don't know what this does, but it's something called shared instance singleton or something. A singleton is an object that has global access and has something to do with instantiating a class instance once.
    class var sharedInstance : NotificationList
    {
        struct Static {
            static let instance: NotificationList = NotificationList()
        }
        return Static.instance
    }
    
    
    func addNotification(_ item: Ingredient) {
        let content = UNMutableNotificationContent()
        content.title = "Food App"
        // get the number of days until expiration
        let date1 = Calendar.current.startOfDay(for: Date.init())
        let date2 = Calendar.current.startOfDay(for: item.exp!)
        let daysToExpiration = Int(Calendar.current.dateComponents([.day], from: date1, to: date2).day!)
        print(daysToExpiration)
        var displayText = ""
        if daysToExpiration == 0 {
            displayText = "today"
        }
        else if daysToExpiration < 7 {
            displayText = "in \(daysToExpiration) days"
        }
        else if daysToExpiration == 7 {
            displayText = "in a week"
        }
        else if daysToExpiration < 14 {
            displayText = "in less than two weeks"
        }
        else if daysToExpiration == 14 {
            displayText = "in two weeks"
        }
        else if daysToExpiration < 21 {
            displayText = "in less than three weeks"
        }
        else if daysToExpiration == 21 {
            displayText = "in three weeks"
        }
        else if daysToExpiration < 31 {
            displayText = "in less than a month"
        }
        else if daysToExpiration == 31 {
            displayText = "in a month"
        }
        else {
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.long
            var formattedDate = formatter.string(from: item.exp!)
            let end = formattedDate.index(formattedDate.endIndex, offsetBy: -6)
            formattedDate = formattedDate.substring(to: end)
            displayText = "on \(formattedDate)"
        }
        
        // text that will be displayed in the notification
        content.body = "Your \"\(item.name)\" is expiring \(displayText)!"
        content.sound = UNNotificationSound.default()
        
        // Deliver the notification at the trigger date
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: item.notificationDate!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Schedule the notification.
        let request = UNNotificationRequest(identifier: item.name, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
    
    
    // This function retrieves the array of item representation from disk, converts it to an array of TodoItem instances using an unnamed closure we pass to map, and sorts that array chronologically. To be perfectly honest, I have no goddamn idea if this actually works cuz I snatched it off a tutorial and changed around some variable names, but hopefully it does.
    /* func allItems() -> [Ingredient]
    {
        let notificationDictionary = UserDefaults.standard.dictionary(forKey: NOTIF_KEY) ?? [:]
        let items = Array(notificationDictionary.values)
        
        return items.map(
            {
                let item = $0 as! [String: AnyObject]
                return Ingredient(name: item["name"] as! String, selected: item["selected"] as! Bool, shoppingListed: item["shoppingListed"] as! Bool, expDuration: item["expDuration"] as! TimeInterval, exp: item["exp"] as? Date, notificationDate: item["notificationDate"] as? Date)!
        }).sorted(by: {(left: Ingredient, right: Ingredient) -> Bool in (left.exp!.compare(right.exp!) == .orderedAscending)
        })
    }*/
    
    /* fileprivate let NOTIF_KEY = "notifications"
     
     func addItem(_ item: Ingredient) {
     // Persist a representation of this todo item in UserDefaults
     var notificationDictionary = UserDefaults.standard.dictionary(forKey: NOTIF_KEY) ?? Dictionary()
     // if notifications hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
     notificationDictionary[item.name] = ["name": item.name, "expiration date": item.exp!]
     // store NSData representation of todo item in dictionary with UUID as key
     UserDefaults.standard.set(notificationDictionary, forKey: NOTIF_KEY) // save/overwrite todo item list
     
     // create a corresponding local notification
     let content = UNMutableNotificationContent()
     content.title = "FoodApp"
     content.subtitle = "Alert!"
     // text that will be displayed in the notification
     content.body = "Your \"\(item.name)\" is expiring soon!"
     // assign a unique identifier to the notification so that we can retrieve it later
     content.userInfo = ["name": item.name]
     content.sound = UNNotificationSound.default()
     
     // create notification
     let notifTriggerComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second,], from: item.notificationDate!)
     let notifTriggerDate = UNCalendarNotificationTrigger(dateMatching: notifTriggerComp, repeats: false)
     let notification = UNNotificationRequest(identifier: item.name, content: content, trigger: notifTriggerDate)
     
     // add notification to list
     let center = UNUserNotificationCenter.current()
     center.add(notification)
     
     } */
    
}
