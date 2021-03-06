//
//  SettingsTableViewController.swift
//  LayoutTest
//
//  Created by CS User on 6/20/17.
//  Copyright © 2017 Princeton University. All rights reserved.
//

import UIKit
import os.log

class SettingsTableViewController: UITableViewController {
    
    //MARK: Properties
    var section = ["Dietary Restrictions", "Allergies"]
    var items = [[Setting]]()
    let app = PublicMethods.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Load any saved items, otherwise load sample data.
        if false {//let savedSettings = loadSettings() {
            //items += savedSettings
        }
        else {
            // Load the default data.
            loadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.section.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SettingsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingsTableViewCell
            else {
                fatalError("The dequeued cell is not an instance of InventoryTableViewCell.")
        }
        
        // Configure the cell...
        let current = items[indexPath.section][indexPath.row]
        cell.setting.text = current.setting
        cell.toggle.isOn = current.isOn
        return cell
    }
    
    //MARK: Actions
    
    @IBAction func switched(_ sender: UISwitch) {
        // Figure out which switch it is
        // Call the correct method based on this
        guard let cell = sender.superview?.superview as? SettingsTableViewCell
            else {
            fatalError("Could not instantiate cell")
        }
        // set the Setting object at the correct index path to isOn = true
        for settingArray in items {
            for settingItem in settingArray {
                if settingItem.setting == cell.setting.text! {
                    settingItem.isOn = !settingItem.isOn
                    if settingItem.isOn {
                     app.addRestriction(restriction: settingItem.setting)
                    }
                    else {
                     app.removeRestriction(restriction: settingItem.setting)
                    }
                    
                }
            }
        }
        
        saveSettings()
        print(cell.setting.text!)
    }
    
    //MARK: Private Functions
    private func loadData()
    {
        items.append([Setting]())
        items.append([Setting]())
        
        items[0].append(Setting(setting: "Vegetarian", isOn: false)!)
        items[0].append(Setting(setting: "Vegan", isOn: false)!)
        items[0].append(Setting(setting: "Gluten Free", isOn: false)!)
        items[0].append(Setting(setting: "Dairy Free", isOn: false)!)
        items[0].append(Setting(setting: "Halal", isOn: false)!)
        items[0].append(Setting(setting: "Kosher", isOn: false)!)
        items[1].append(Setting(setting: "Milk", isOn: false)!)
        items[1].append(Setting(setting: "Eggs", isOn: false)!)
        items[1].append(Setting(setting: "Fish", isOn: false)!)
        items[1].append(Setting(setting: "Shellfish", isOn: false)!)
        items[1].append(Setting(setting: "Tree Nuts", isOn: false)!)
        items[1].append(Setting(setting: "Peanuts", isOn: false)!)
        items[1].append(Setting(setting: "Wheat", isOn: false)!)
        items[1].append(Setting(setting: "Soybeans", isOn: false)!)
    }
    
    private func saveSettings()
    {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(items, toFile: Setting.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Settings successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save settings...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadSettings() -> [[Setting]]?
    {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Setting.ArchiveURL.path) as? [[Setting]]
    }
}
