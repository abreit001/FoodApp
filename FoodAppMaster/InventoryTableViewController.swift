//
//  InventoryTableViewController.swift
//  LayoutTest
//
//  Created by Abby Breitfeld on 6/19/17.
//  Copyright © 2017 Princeton University. All rights reserved.
//

import UIKit

class InventoryTableViewController: UITableViewController {
    
    //MARK: Properties
    var categories = [Category]()
    var sections = [String]()
    let app = PublicMethods.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
            // The following line should be commented UNLESS it is to reset the default such that it is the first time the app is launched.
            // UserDefaults.standard.set(false, forKey: "launchedBefore")
        } else {
            print("First launch, setting UserDefault.")
            let alertController = UIAlertController(title: "Welcome!", message: "Hi! Welcome to Rype, the smart kitchen assistant that helps you to buy, cook and eat as sustainably as possible! Rype tracks your purchasing and consumption habits and helps you to make the cooking and purchasing decisions that minimize your food waste. In addition to your habits, Rype knows the expiration dates of the food you purchase when you add it to your pantry and uses this data to determine the best recipes for you to make with the food available to you. Add items to your pantry manually, or take a photo of your reciept and our optical character recognition software will do it automatically for you! Rype also contains a shopping list function to help you keep track of what you should buy, and when! Rype is combatible with almost every dietary lifestyle or restriction, and you can set your preferences for recipe suggestions in the settings tab! Enjoy, and happy green eating!", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        sections = app.sections
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "InventoryTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? InventoryTableViewCell
            else {
                fatalError("The dequeued cell is not an instance of InventoryTableViewCell.")
        }
        
        // Configure the cell
        let current = categories[indexPath.row]
        cell.categoryName.text = current.name
        cell.icon.image = current.icon
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        guard let categoryDetailViewController = segue.destination as? IngredientTableViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        // Pass the selected object to the new view controller.
        guard let cell = sender as? InventoryTableViewCell else {
                fatalError("The dequeued cell is not an instance of IngredientTableViewCell.")
        }
        categoryDetailViewController.ingredientCategory = tableView.indexPath(for: cell)?.row
    }
    
    
    //MARK: Private Methods
    
    private func loadData() {
        // Load all images
        var icons = [UIImage]()
        icons.append(UIImage(named: "dairy")!)
        icons.append(UIImage(named: "meat")!)
        icons.append(UIImage(named: "vegetables")!)
        icons.append(UIImage(named: "fruits")!)
        icons.append(UIImage(named: "fish")!)
        icons.append(UIImage(named: "grains")!)
        icons.append(UIImage(named: "spices")!)
        icons.append(UIImage(named: "nut")!)
        icons.append(UIImage(named: "legumes")!)
        icons.append(UIImage(named: "condiments")!)
        icons.append(UIImage(named: "dessert")!)
        icons.append(UIImage(named: "soup")!)
        icons.append(UIImage(named: "beverage")!)
        
        // Initialize category names
        for i in 0..<sections.count {
            guard let category = Category(name: sections[i], icon: icons[i]) else {
                fatalError("Unable to instantiate category1")
            }
            categories.append(category)
        }
    }

}
