//
//  RecipeDetailViewModel.swift
//  RecipeApp
//
//  Created by Tushar  Jadhav on 2019-01-17.
//  Copyright © 2019 Shital  Jadhav. All rights reserved.
//

import Foundation

class RecipeDetailViewModel  {
    
    weak var service :NetworkServiceClient!
    var items = [RecipeViewModelItem]()
    
    init(service : NetworkServiceClient = NetworkServiceClient.shared) {
        self.service = service
    }
    
    func configureViewModelItems(recipe : Recipe) {
        
        let imageItem = RecipeViewModelImageItem(imageUrl: recipe.recipeImageUrl)
        items.append(imageItem)
        
        if let ingredients = recipe.ingredients {
            let item = RecipeViewModelIngredientItem(ingredients:ingredients)
            items.append(item)
        }
        
        let item = RecipeViewModelInfoItem(publisher: recipe.publisher, socialRank: String(recipe.socialRank), instructionViewUrl: recipe.recipeInstructionUrl, recipeViewUrl: recipe.recipeViewUrl)
        items.append(item)
    }
    
    func fetchRecipeDetail(recipeId: String, completion: @escaping (Result<Bool, DataResponseError>) -> Void) {
        
        let paramater = ["rId" : recipeId]
        service.fetchData(apiName: "get", parameters: paramater, genericType: RecipeDetailResponseModel.self) {[weak self] result  in
            
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            case .success(let response):
                DispatchQueue.main.async {
                    //  self?.recipe = response.recipe
                    self?.configureViewModelItems(recipe: response.recipe)
                    completion(Result.success(true))
                }
            }
        }
    }
}
