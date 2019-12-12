//
//  RecipeViewModel.swift
//  RecipeApp
//
//  Created by Tushar  Jadhav on 2019-01-17.
//  Copyright © 2019 Shital  Jadhav. All rights reserved.
//

import Foundation

class RecipeViewModel  {
    
    weak var service :RecipeServiceProtocol?
    
    var recipes : [Recipe] = []
    var filteredRecipes : [Recipe] = []
    var searchRecipeText : String?
    
    var currentPage = 1
    var isLastPage = false
    private var isFetchInProgress = false
    
    init(service : RecipeServiceProtocol?) {
        self.service = service
    }
    
    var searchTotalCount: Int {
        return filteredRecipes.count
    }
    
    var currentCount: Int {
        return recipes.count
    }
    
    func recipe(at index: Int) -> Recipe {
        return recipes[index]
    }
    
    
    func fetchRecipes(_ completion: @escaping (Result<Bool, DataResponseError>) -> Void) {
        
        guard let service = service else {
            completion(Result.failure(DataResponseError.custom("Missing service")))
            return
        }
        
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        
        var paramater = ["page": String(self.currentPage)]
        
        if let searchRecipe = searchRecipeText {
            paramater["q"] = searchRecipe
        }
        
        
        service.fetchData(apiName: "search", parameters: paramater, genericType: RecipeResponseModel.self) {[weak self] result  in
            
            switch result {
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isFetchInProgress = false
                    completion(Result.failure(error))
                }
            case .success(let response):
                
                self?.isFetchInProgress = false
                
                if (self?.searchRecipeText) != nil {
                    self?.filteredRecipes.append(contentsOf: response.recipes)
                }
                else {
                    self?.currentPage += 1
                    self?.recipes.append(contentsOf: response.recipes)
                    
                    //Check last page and set flag true
                    if response.count < 1 {
                        self?.isLastPage = true
                    }
                }
                
                DispatchQueue.main.async {
                    completion(Result.success(true))
                }
            }
        }
    }
    
    //Clear search recipe result
    func clearSearchResult() {
        
        if searchTotalCount != 0 {
            self.filteredRecipes.removeAll()
        }
    }
}
