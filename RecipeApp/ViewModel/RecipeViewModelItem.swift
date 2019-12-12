//
//  RecipeViewModelItem.swift
//  RecipeApp
//
//  Created by Tushar  Jadhav on 2019-01-19.
//  Copyright © 2019 Shital  Jadhav. All rights reserved.
//

import Foundation

enum RecipeViewModelItemType {
    case recipeImage
    case ingredient
    case info
}

protocol RecipeViewModelItem {
    var type: RecipeViewModelItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String  { get }
}

struct RecipeViewModelImageItem: RecipeViewModelItem {
    var imageUrl: String
    
    var type: RecipeViewModelItemType {
        return .recipeImage
    }
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return 1
    }
}

struct RecipeViewModelIngredientItem: RecipeViewModelItem {
    
    var type: RecipeViewModelItemType {
        return .ingredient
    }
    var sectionTitle: String {
        return "Ingredients"
    }
    
    let ingredients: [String]
    
    var rowCount: Int {
        return ingredients.count
    }
}

struct RecipeViewModelInfoItem: RecipeViewModelItem {
    
    var type: RecipeViewModelItemType {
        return .info
    }
    var sectionTitle: String {
        return "Info"
    }
    
    var publisher: String
    var socialRank: String
    var instructionViewUrl: String
    var recipeViewUrl: String
    
    var rowCount: Int {
        return 1
    }
}
