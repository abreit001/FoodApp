//
//  IngredientTableViewController.swift
//  LayoutTest
//
//  Created by Abby Breitfeld on 6/19/17.
//  Copyright © 2017 Princeton University. All rights reserved.
//

import UIKit
import UserNotifications
import os.log

class IngredientTableViewController: UITableViewController {

    //MARK: Properties
    var ingredientCategory: Int?
    var ingredients = [Ingredient]()
    var sections = [String]()
    var selectedRow = -1
    let app = PublicMethods.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = app.sections
        
        ingredients = app.loadIngredients(section: ingredientCategory!)!
        
        // Change the title of the scene
        navigationItem.title = sections[ingredientCategory!]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Load any saved items
        ingredients = app.loadIngredients(section: ingredientCategory!)!
        tableView.reloadData()
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
        return ingredients.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "IngredientTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? IngredientTableViewCell
            else {
                fatalError("The dequeued cell is not an instance of IngredientTableViewCell.")
        }
        
        // Configure the cell
        let current = ingredients[indexPath.row]
        
        cell.name.text = current.name
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        cell.exp.text = formatter.string(from: current.exp!)
        // turn red after the user has been notified of its impending expiration
        // Calendar.current.component(.day, from: current.notificationDate!) >= Calendar.current.component(.day, from: Date.init())
        if current.notificationDate! <= Date.init() {
            cell.exp.textColor = .red
        }
        else {
            cell.exp.textColor = .black
        }
        
        if selectedRow == indexPath.row {
            cell.backgroundColor = UIColor(red: 9/255, green: 80/255, blue: 208/255, alpha: 10/100)
        }
        else {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Alert the user
            let alertController = UIAlertController(title: "Deleting " + ingredients[indexPath.row].name, message: "Would you like add this item to your shopping list?", preferredStyle: .alert)
            
            let shoppingListAction = UIAlertAction(title: "Add to Shopping List", style: .default, handler: { (action) in
                //Delete from query
                self.app.deleteFromQuery(name: self.ingredients[indexPath.row].name)
                // Delete the row from the data source
                self.ingredients[indexPath.row].selected = false
                tableView.reloadRows(at: [indexPath], with: .fade)
                // Add to shopping list
                self.ingredients[indexPath.row].shoppingListed = true
                // Update Priority
                let timeLeft = self.ingredients[indexPath.row].exp?.timeIntervalSince(Date.init())
                if  Int(timeLeft!) < 259200 {
                    self.ingredients[indexPath.row].priority = self.ingredients[indexPath.row].priority! + 1
                }
                // Reset expiration and notification dates
                self.ingredients[indexPath.row].exp = Date(timeIntervalSinceReferenceDate: 0)
                self.ingredients[indexPath.row].notificationDate = Date(timeIntervalSinceReferenceDate: 0)
                // Save data
                self.app.saveIngredients(section: self.ingredientCategory!, ingredients: self.ingredients)
            })
            alertController.addAction(shoppingListAction)
            
            let deleteAction = UIAlertAction(title: "Do Not Add to Shopping List", style: .default, handler: { (action) in
                //Delete from query
                self.app.deleteFromQuery(name: self.ingredients[indexPath.row].name)
                // Delete the row from the data source
                self.ingredients[indexPath.row].selected = false
                tableView.reloadRows(at: [indexPath], with: .fade)
                // Update Priority
                let timeLeft = self.ingredients[indexPath.row].exp?.timeIntervalSince(Date.init())
                if  Int(timeLeft!) < 259200 {
                    self.ingredients[indexPath.row].priority = self.ingredients[indexPath.row].priority! + 1
                }
                // Reset expiration and notification dates
                self.ingredients[indexPath.row].exp = Date(timeIntervalSinceReferenceDate: 0)
                self.ingredients[indexPath.row].notificationDate = Date(timeIntervalSinceReferenceDate: 0)
                // Save data
                self.app.saveIngredients(section: self.ingredientCategory!, ingredients: self.ingredients)
            })
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row at \(indexPath.row)")
        selectedRow = indexPath.row
        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.scrollToRow(at: IndexPath(row: selectedRow, section: 0), at: .top, animated: false)
    }*/
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ingredients[indexPath.row].selected == true {
            return UITableViewAutomaticDimension
        }
        else {
            return 0
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        guard let navController = segue.destination as? UINavigationController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        guard let addViewController = navController.viewControllers.first as? AddTableViewController  else {
            fatalError("Unexpected destination: \(String(describing: navController.viewControllers.first))")
        }
        
        // Pass the selected object to the new view controller.
        addViewController.ingredients = self.ingredients
    }
    
    //MARK: Actions
    
    @IBAction func unwindToIngredientList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddTableViewController {
            for i in 0..<sourceViewController.selectedRows.count {
                if sourceViewController.selectedRows[i] {
                    // Add to pantry
                    app.addToPantry(item: ingredients[i])
                }
            }
            tableView.reloadSections([0], with: .fade)
            app.saveIngredients(section: ingredientCategory!, ingredients: ingredients)
        }
    }
    
    //MARK: Private Methods
    
    /*private func savePantry() {
        let ArchiveURL = Ingredient.DocumentsDirectory.appendingPathComponent(sections[ingredientCategory!])
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ingredients, toFile: ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Pantry successfully saved.", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save pantry items...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadPantry() -> [Ingredient]? {
        let ArchiveURL = Ingredient.DocumentsDirectory.appendingPathComponent(sections[ingredientCategory!])
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL.path) as? [Ingredient]
    }*/
}
