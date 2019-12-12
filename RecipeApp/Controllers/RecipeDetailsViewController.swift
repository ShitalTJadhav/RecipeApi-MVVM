//
//  RecipeDetailsViewController.swift
//  RecipeApp
//
//  Created by Tushar  Jadhav on 2019-01-17.
//  Copyright © 2019 Shital  Jadhav. All rights reserved.
//

import UIKit
import SafariServices

class RecipeDetailsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    let cellIds = ["ImageCellId", "IngredientCellId", "RecipeInfoCellId"]
    var viewModel = RecipeDetailViewModel()
    var recipeId : String!
    var recipeName : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = recipeName
        
        //Set Indicator setting
        indicatorView.color = ColorPalette.AppMainColor
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        
        //Fetch recipe details
        viewModel.fetchRecipeDetail(recipeId:recipeId, completion: {[weak self] result in
            
            self?.indicatorView.stopAnimating()

            switch result {
            case .failure(_):
                self?.showNetworkErrorMessage()
            case .success(_):
                // Do any additional setup after loading the view.
                self?.indicatorView.stopAnimating()
                
                self?.setUpTableView()
                self?.tableView.reloadData()                
            }
        })
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - UI Setup methods
    
    func setUpTableView()  {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.tableFooterView = UIView()
        tableView.accessibilityIdentifier = "RecipeDetailsTableViewIdentifier"

    }
}

extension RecipeDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.items[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = ColorPalette.AppMainColor.withAlphaComponent(0.5)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 230
        case 1:
            return UITableView.automaticDimension
        case 2:
            return 160
        default: break
            
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = cellIds[indexPath.section]
        
        let item = viewModel.items[indexPath.section]
        
        switch item.type {
        case .recipeImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RecipeImageTableViewCell
            cell.item = item as? RecipeViewModelImageItem
            return cell
        case .ingredient:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RecipeIngredientTableViewCell
                cell.ingredient = (item as! RecipeViewModelIngredientItem).ingredients[indexPath.row]
            
            return cell
        case .info:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RecipeInfoTableViewCell
            cell.item = item as? RecipeViewModelInfoItem
            
            //Handle button action events
            cell.viewInstructionButtonBlock = { url in
                self.openUrlInWebview(urlString: url)
            }
            
            cell.viewOriginalButtonBlock = { url in
                self.openUrlInWebview(urlString: url)
            }
            
            return cell
        }
    }
    
    func openUrlInWebview(urlString: String) {
        
        //Open url in default mobile browser
      /*
         if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:])
        }
         */
        
        let vc = SFSafariViewController(url: URL(string: urlString)!, configuration:.init())
        self.present(vc, animated: true)
        
//        //Open url in another view
//        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewViewController") as? WebviewViewController {
//            viewController.urlString = urlString
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
    }
}
