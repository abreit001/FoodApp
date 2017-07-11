//
//  MasterViewController.swift
//  Recipy
//
//  Created by Amaury Vidal on 19/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import UIKit

class RecipesListViewController: UIViewController, HolderViewDelegate {
    
    private let showDetailSegue = "showDetail"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = RecipesListViewModel()
    let app = PublicMethods.sharedInstance
    var bool = false
    var query = [Ingredient]()
    var detailViewController: RecipeDetailViewController? = nil
    var loadingSpinner: UIActivityIndicatorView? // Spinner to show when we are loading more rows
    var loadingMore: Bool = false {
        didSet {
            if loadingMore {
                loadingSpinner?.startAnimating()
            } else {
                loadingSpinner?.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        query = app.useMe
        addLoadingIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // DELETE
        // navigationController?.isNavigationBarHidden = true
        // Unclear if you need to keep or not
        if let selectedRow = tableView?.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
              // addHolderView()
    
        
    }
    
    //////////////////////////////////////////
    //MARK: Loader Animation
    var holderView = HolderView(frame: CGRect.zero)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //call()
        

        for ingredient in query {
            fetchRecipes(query: ingredient.name)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addHolderView() {
        let boxSize: CGFloat = 100.0
        holderView.frame = CGRect(x: view.bounds.width / 2 - boxSize / 2,
                                  y: view.bounds.height / 2 - boxSize / 2,
                                  width: boxSize,
                                  height: boxSize)
        holderView.parentFrame = view.frame
        holderView.delegate = self
        view.addSubview(holderView)
        holderView.addOval()
    }
    
    func animateLabel() {
        // 1
        holderView.removeFromSuperview()
        view.backgroundColor = Colors.blue
        
        // 2
        let label: UILabel = UILabel(frame: view.frame)
        label.textColor = Colors.white
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 50.0)
        label.textAlignment = NSTextAlignment.center
        label.text = "Show my meals!"
        label.transform = label.transform.scaledBy(x: 0.25, y: 0.25)
        view.addSubview(label)
        
        // 3
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions(),
                       animations: ({
                        label.transform = label.transform.scaledBy(x: 4.0, y: 4.0)
                       }), completion: { finished in
                        self.next()
        })
    }
    
    func next() {
        view.backgroundColor = Colors.white
       // view.subviews.map({ $0.removeFromSuperview() })
        holderView.removeFromSuperview()
    }
    
    
    //////////////////////////////////////////
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showDetailSegue {
            if let indexPath = self.tableView.indexPathForSelectedRow,
                let recipe = viewModel.recipe(at: indexPath.row) {
                let controller = segue.destination as! RecipeDetailViewController
                controller.viewModel = RecipeDetailViewModel(recipe: recipe)
                controller.navigationItem.leftItemsSupplementBackButton = true
                
                view.endEditing(true)
            }
        }
    }
    
    
    // MARK: - API
    
    func fetchRecipes(query: String) {
        print("method start")
        print(app.useMe)
        var finalRecipes = [Recipe]()
        var count = 0
        var ownedRecipes = [Recipe]()
        // Display an indicator that we're fetching from network
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        var gate = true
        print("fetching recipes")
        print("1")
        self.viewModel.recipes(matching: query) { recipes in
            print("2")
            for item in recipes {
                ownedRecipes.append(item)
                print("3")
            }
            gate = false
        }
        while gate {}
        gate = true
        print("recipes fetched")
        
        print("converting recipes")
        for item in ownedRecipes {
            print("1")
            self.viewModel.recipe(id: item.recipeId) { recipe in
                print("2")
                let ingredients = recipe?.ingredients
                for ingredient in ingredients! {
                    print("3")
                    for thing in self.app.owned {
                        if (ingredient.localizedCaseInsensitiveContains(thing.name)) {
                            count += 1
                        }
                    }
                }
                
                if Double(count) > Double((ingredients?.count)!) * 0.1  || true {
                    finalRecipes.append(item)
                }
                count = 0
                gate = false
            }
            while gate{}
            gate = true
        }
        
        
        print("recipes converted")
        print("length ", finalRecipes.count)
        print("done!")
        self.insertRecipes(recipes: finalRecipes)
        // Hide the indicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.loadingMore = false
    }
    
    func insertRecipes(recipes: [Recipe]) {
        if recipes.count > 0 {
            self.tableView.beginUpdates()
            viewModel = viewModel.added(recipes: recipes)
            var indexPathsToInsert = [IndexPath]()
            let start = self.tableView.numberOfRows(inSection: 0)
            let end = start + recipes.count - 1
            for i in start...end {
                indexPathsToInsert += [IndexPath(row: i, section: 0)]
            }
            self.tableView.insertRows(at: indexPathsToInsert, with: .automatic)
            self.tableView.endUpdates()
            
            print("Something is here")
            
            for thing in app.useMe {
                print("look!")
                print(thing.name)
            }
            
        
        }
    }
}


// MARK: - UITableView
extension RecipesListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.nbRecipes
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.identifier, for: indexPath) as! RecipeCell
        cell.textLabel?.text = viewModel.title(at: indexPath.row)
        return cell
    }
}


// MARK: - Infinite Scroll
extension RecipesListViewController {
    
    /// Add a loading indicator when we are fetching more recipes
    func addLoadingIndicator() {
        if loadingSpinner == nil {
            loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            loadingSpinner?.color = UIColor(red: 22/255, green: 106.0/255, blue: 176/255, alpha: 1)
            loadingSpinner?.hidesWhenStopped = true
            tableView.tableFooterView = loadingSpinner
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // calculates where the user is in the y-axis
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height,
            loadingMore == false,
            !viewModel.noMoreResults,
            let query = searchBar.text {
            
            loadingMore = true
            
           // viewModel = viewModel.incrementedPage()
            
            fetchRecipes(query: query)
           
        }
    }
}

// MARK: - Search Bar Delegate
extension RecipesListViewController: UISearchBarDelegate {
    // On return button launch the search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, !query.isEmpty {
            
            // Clear previous results
            viewModel = viewModel.reseted()
            tableView.reloadData()
            view.endEditing(true)
            
            fetchRecipes(query: query)
        }
    }
}


