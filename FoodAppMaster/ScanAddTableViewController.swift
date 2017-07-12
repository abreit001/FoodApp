//
//  ScanAddTableViewController.swift
//  FoodAppMaster
//
//  Created by Abby Breitfeld on 7/12/17.
//  Copyright © 2017 Princeton University. All rights reserved.
//

import UIKit

class ScanAddTableViewController: UITableViewController {

    var ingredients = [[Ingredient]]()
    var foundItems = [[Bool]]()
    var selected = [[Bool]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<foundItems.count {
            selected.append([Bool]())
            for _ in foundItems[i] {
                selected[i].append(false)
            }
        }
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
        let cellIdentifier = "ScanAddTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScanAddTableViewCell
            else {
                fatalError("The dequeued cell is not an instance of ScanAddTableViewCell.")
        }
        
        // Configure the cell
        let current = ingredients[indexPath.section][indexPath.row]
        cell.name.text = current.name
        
        // Select or deselect
        if selected[indexPath.section][indexPath.row] {
            cell.accessoryType = .checkmark
            cell.backgroundColor = UIColor(red: 9/255, green: 80/255, blue: 208/255, alpha: 10/100)
        }
        else {
            cell.accessoryType = .none
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if foundItems[indexPath.section][indexPath.row] {
            return 0
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return PublicMethods.sharedInstance.sections[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected[indexPath.section][indexPath.row] = !selected[indexPath.section][indexPath.row]
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    //MARK: Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
