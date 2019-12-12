//
//  Recipe.swift
//  RecipeApp
//
//  Created by Tushar  Jadhav on 2019-01-17.
//  Copyright © 2019 Shital  Jadhav. All rights reserved.
//

import Foundation

struct Recipe : Decodable {
    
    var publisher: String
    var recipeName: String
    var recipeId: String
    var recipeViewUrl: String
    var recipeImageUrl: String
    var recipeInstructionUrl: String
    var socialRank: Double
    var publisherUrl: String
    let ingredients: [String]?


    enum CodingKeys: String, CodingKey {
        case publisher
        case recipeName = "title"
        case recipeId = "recipe_id"
        case recipeViewUrl = "f2f_url"
        case recipeImageUrl = "image_url"
        case recipeInstructionUrl = "source_url"
        case socialRank = "social_rank"
        case publisherUrl = "publisher_url"
        case ingredients
    }
    
}


