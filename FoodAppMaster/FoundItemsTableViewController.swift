//
//  FoundItemsTableViewController.swift
//  FoodAppMaster
//
//  Created by Abby Breitfeld on 7/12/17.
//  Copyright © 2017 Princeton University. All rights reserved.
//

import UIKit

class FoundItemsTableViewController: UITableViewController {

    //MARK: Properties
    var ingredients = [[Ingredient]]()
    var foundItems = [[Bool]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ingredients.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "FoundItemsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FoundItemsTableViewCell
            else {
                fatalError("The dequeued cell is not an instance of FoundItemsTableViewCell.")
        }
        
        // Configure the cell
        let current = ingredients[indexPath.section][indexPath.row]
        cell.name.text = current.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if foundItems[indexPath.section][indexPath.row] {
            return UITableViewAutomaticDimension
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return PublicMethods.sharedInstance.sections[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        for i in 0..<ingredients[section].count {
            if foundItems[section][i] {
                return UITableViewAutomaticDimension
            }
        }
        return 0
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            foundItems[indexPath.section][indexPath.row] = false
            tableView.reloadRows(at: [indexPath], with: .fade)
            tableView.reloadSections([indexPath.section], with: .fade)
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    //MARK: Actions
    
    @IBAction func unwindToFindItemsList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ScanAddTableViewController {
            for i in 0..<sourceViewController.selected.count {
                for j in 0..<sourceViewController.selected[i].count {
                    if sourceViewController.selected[i][j] {
                        foundItems[i][j] = true
                    }
                }
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "addItems" {
            guard let navController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let addViewController = navController.viewControllers.first as? ScanAddTableViewController  else {
                fatalError("Unexpected destination: \(String(describing: navController.viewControllers.first))")
            }
            
            // Pass the selected object to the new view controller.
            addViewController.ingredients = self.ingredients
            addViewController.foundItems = self.foundItems
        }

    }

}
