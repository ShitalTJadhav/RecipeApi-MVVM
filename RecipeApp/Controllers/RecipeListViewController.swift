//
//  RecipeListViewController.swift
//  RecipeApp
//
//  Created by Tushar  Jadhav on 2019-01-17.
//  Copyright © 2019 Shital  Jadhav. All rights reserved.
//

import UIKit

class RecipeListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    private var viewModel: RecipeViewModel!
    private let cellId = "CellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Food2Fork"
        
        // Do any additional setup after loading the view.
        viewModel = RecipeViewModel(service: NetworkServiceClient.shared)

        //Set up indicator
        setUpIndicatorView()
        
        //Set Search bar 
        setUpSearchBar()
        
        //Set table view delegate
        setUpTableView()
        
        //Fetch recipes initial list
        fetchRecipesList()
        
    }
    
    // MARK: - Api Call methods

    func fetchRecipesList()  {
        
        viewModel.fetchRecipes({[weak self] result in
            
            self?.indicatorView.stopAnimating()
            
            switch result {
            case .failure(let error):
              self?.showAlertWithMessage(message: "\(error)")
            case .success(_):
                self?.tableView.isHidden = false
                self?.searchBar.isHidden = false
                self?.tableView.reloadData()
            }
        })
    }
    
    
    // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        if segue.identifier == "DetailsViewController" {
            if let detailViewController = segue.destination as? RecipeDetailsViewController {
                let cell = sender as! RecipeTableViewCell
                detailViewController.recipeId = cell.model!.recipeId
                detailViewController.recipeName = cell.model!.recipeName
            }
        }
     }
    
    // MARK: - Setup / Private methods
    
    fileprivate func setUpIndicatorView() {
        //Set Indicator setting
        indicatorView.color = ColorPalette.AppMainColor
        indicatorView.hidesWhenStopped = true
        indicatorView.accessibilityIdentifier = "RecipeList_IndicatioView"
        indicatorView.startAnimating()
    }
    
    fileprivate func setUpSearchBar() {
        //Set up search bar
        searchBar.delegate = self
        searchBar.placeholder = "Search recipe by name"
        searchBar.isHidden = true
        searchBar.accessibilityIdentifier = "Search_Recipe"
    }
    
    fileprivate func setUpTableView() {
        
        tableView.backgroundColor = ColorPalette.background
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.accessibilityIdentifier = "RecipeListTableViewIdentifier"
        
        // NOTE: - Registering the cell programmatically
       // tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    
    fileprivate func isSearching() -> Bool {
        let searchBarIsEmpty = searchBar.text?.isEmpty ?? true
        return !searchBarIsEmpty
    }
    
    fileprivate func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row == viewModel.currentCount - 1 && !viewModel.isLastPage
    }
}

// MARK: - UITableViewDataSource

extension RecipeListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching() {
            return viewModel.searchTotalCount
        }
        else {
            return viewModel.currentCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RecipeTableViewCell
        cell.tag = indexPath.row
        
        if isSearching() {
            cell.model = self.viewModel.filteredRecipes[indexPath.row]
        }
        else {
            cell.model = self.viewModel.recipes[indexPath.row]
        }
        return cell
    }
}

extension RecipeListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        //Pagination implement only for all list not for searching
        if indexPaths.contains(where: isLoadingCell) && !isSearching() {
            
            viewModel.fetchRecipes({ result in
                switch result {
                case .success(_):
                    self.tableView.reloadData()
                case .failure(_):break
                }
            })
        }
    }
}

// MARK: - UISearchBar Delegate

extension RecipeListViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool  {
        self.searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        // Remove focus from the search bar.
        self.searchBar.endEditing(true)
        
        //Clear prevoius search recipe result
        viewModel.clearSearchResult()
        
        //New Search recipe result
        viewModel.searchRecipeText = searchBar.text!
        viewModel.fetchRecipes({ result in
            self.tableView.reloadData()
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.setShowsCancelButton(false, animated: true)
        
        // Remove focus from the search bar.
        self.searchBar.endEditing(true)
        
        //Clear search result
        viewModel.clearSearchResult()
        
        self.tableView.reloadData()
    }
}

