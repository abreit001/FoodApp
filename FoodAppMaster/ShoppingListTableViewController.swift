//
//  ShoppingListTableViewController.swift
//  LayoutTest
//
//  Created by Abby Breitfeld on 6/21/17.
//  Copyright © 2017 Princeton University. All rights reserved.
//

import UIKit
import os.log

class ShoppingListTableViewController: UITableViewController {

    //MARK: Properties
    var ingredients = [[Ingredient]]()
    var sections = [String]()
    let app = PublicMethods.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sections = app.sections
        
        // Load any saved items, otherwise load sample data.
        ingredients = app.loadAllIngredients()!
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ingredients = app.loadAllIngredients()!
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        for item in ingredients[section] {
            if item.shoppingListed {
                return UITableViewAutomaticDimension
            }
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ShoppingListTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ShoppingListTableViewCell
            else {
                fatalError("The dequeued cell is not an instance of ShoppingListTableViewCell.")
        }
        
        // Configure the cell...
        let current = ingredients[indexPath.section][indexPath.row]
        cell.item.text = current.name
        
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        self.tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor(red: 9/255, green: 80/255, blue: 208/255, alpha: 10/100)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
        self.tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.white
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ingredients[indexPath.section][indexPath.row].shoppingListed {
            return UITableViewAutomaticDimension
        }
        else {
            return 0
        }
    }

    // Override to support editing the table view.
    /*override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Alert the user
            let alertController = UIAlertController(title: "Deleting " + ingredients[indexPath.section][indexPath.row].name, message: "Would you like add this item to your pantry?", preferredStyle: .alert)
            
            let shoppingListAction = UIAlertAction(title: "Add to Pantry", style: .default, handler: { (action) in
                // Delete the row from the data source
                self.ingredients[indexPath.section][indexPath.row].shoppingListed = false
                tableView.reloadSections([indexPath.section], with: .fade)
                // Add to shopping list
                self.ingredients[indexPath.section][indexPath.row].selected = true
                self.savePantry(section: indexPath.section)
            })
            alertController.addAction(shoppingListAction)
            
            let deleteAction = UIAlertAction(title: "Do Not Add to Pantry", style: .default, handler: { (action) in
                // Delete the row from the data source
                self.ingredients[indexPath.section][indexPath.row].shoppingListed = false
                tableView.reloadRows(at: [indexPath], with: .fade)
                self.savePantry(section: indexPath.section)
            })
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }*/

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Actions
    
    @IBAction func updateList(_ sender: UIBarButtonItem) {
        if tableView.indexPathsForSelectedRows != nil {
            // Alert the user
            let alertController = UIAlertController(title: "Deleting from Shopping List", message: "Would you like add the selected items to your pantry?", preferredStyle: .alert)
            
            let shoppingListAction = UIAlertAction(title: "Add to Pantry", style: .default, handler: { (action) in
                for indexPath in self.tableView.indexPathsForSelectedRows! {
                    // Add to pantry
                    self.app.addToPantry(item: self.ingredients[indexPath.section][indexPath.row])
                    // Save and reload
                    self.app.saveIngredients(section: indexPath.section, ingredients: self.ingredients)
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                    self.tableView.reloadSections([indexPath.section], with: .fade)
                }
            })
            alertController.addAction(shoppingListAction)
            
            let deleteAction = UIAlertAction(title: "Do Not Add to Pantry", style: .default, handler: { (action) in
                for indexPath in self.tableView.indexPathsForSelectedRows! {
                    // Delete the row from the data source
                    self.ingredients[indexPath.section][indexPath.row].shoppingListed = false
                    // Save and reload
                    self.app.saveIngredients(section: indexPath.section, ingredients: self.ingredients)
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                    self.tableView.reloadSections([indexPath.section], with: .fade)
                }
            })
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
    //MARK: Private Methods
    
    /*private func loadPantry() -> [[Ingredient]]? {
        var array = [[Ingredient]]()
        for _ in 0..<sections.count {
            array.append([Ingredient]())
        }
        
        for i in 0..<sections.count {
            let ArchiveURL = Ingredient.DocumentsDirectory.appendingPathComponent(sections[i])
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
