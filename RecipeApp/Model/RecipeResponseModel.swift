//
//  RecipeResponseModel.swift
//  RecipeApp
//
//  Created by Tushar  Jadhav on 2019-01-17.
//  Copyright © 2019 Shital  Jadhav. All rights reserved.
//

import Foundation

struct RecipeResponseModel : Decodable {
    var count: Int
    var recipes: [Recipe]
}
