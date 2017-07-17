//
//  AddTableViewController.swift
//  LayoutTest
//
//  Created by Abby Breitfeld on 6/22/17.
//  Copyright © 2017 Princeton University. All rights reserved.
//

import UIKit
import os.log

class AddTableViewController: UITableViewController {
    
    //MARK: Properties
    var ingredients = [Ingredient]()
    var selectedRows = [Bool]()
    @IBOutlet weak var doneButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<ingredients.count {
            selectedRows.append(false)
        }
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
        let cellIdentifier = "AddTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AddTableViewCell
            else {
                fatalError("The dequeued cell is not an instance of AddTableViewCell.")
        }
        
        // Configure the cell
        let current = ingredients[indexPath.row]
        cell.name.text = current.name
        
        // Select or deselect
        if selectedRows[indexPath.row] {
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
        if ingredients[indexPath.row].selected {
            return 0
        }
        else {
            return UITableViewAutomaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRows[indexPath.row] = !selectedRows[indexPath.row]
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    // MARK: - Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === doneButton
            else {
                os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
                return
        }
    }

}
