//
//  ScanAddTableViewController.swift
//  FoodAppMaster
//
//  Created by Abby Breitfeld on 7/12/17.
//  Copyright © 2017 Princeton University. All rights reserved.
//

import UIKit
import os.log

class ScanAddTableViewController: UITableViewController, UISearchBarDelegate {

    //MARK: Properties
    
    var ingredients = [[Ingredient]]()
    var foundItems = [[Bool]]()
    var selected = [[Bool]]()
    var searchActive = false
    var filtered = [[Bool]]()
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize filtered and selected to the correct length
        for i in 0..<foundItems.count {
            selected.append([Bool]())
            filtered.append([Bool]())
            for _ in foundItems[i] {
                selected[i].append(false)
                filtered[i].append(false)
            }
        }
        searchBar.delegate = self
        searchBar.showsCancelButton = true
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchActive {
            return nil
        }
        return PublicMethods.sharedInstance.sections[section]
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
        else if searchActive {
            if filtered[indexPath.section][indexPath.row] {
                return UITableViewAutomaticDimension
            }
            else {
                return 0
            }
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected[indexPath.section][indexPath.row] = !selected[indexPath.section][indexPath.row]
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    //MARK: Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
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
    
    //MARK: Searching
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = ""
        searchActive = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchActive = true
        for i in 0..<ingredients.count {
            for j in 0..<ingredients[i].count - 1 {
                if ingredients[i][j].name.localizedCaseInsensitiveContains(searchText) {
                    filtered[i][j] = true
                }
                else {
                  filtered[i][j] = false
                }
            }
        }
        tableView.reloadData()
    }

}
