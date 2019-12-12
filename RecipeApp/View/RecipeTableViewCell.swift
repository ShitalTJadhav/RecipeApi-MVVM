//
//  RecipeTableViewCell.swift
//  RecipeApp
//
//  Created by Tushar  Jadhav on 2019-01-17.
//  Copyright © 2019 Shital  Jadhav. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeNameLabel: UILabel?
    @IBOutlet weak var recipeImageView: AsyncImageView?
    
    var model: Recipe? {
        didSet {
            guard let model = model else {
                return
            }
            self.recipeNameLabel?.text = model.recipeName
            //self.recipeImageView?.setImage(from: model.recipeImageUrl)
            self.recipeImageView?.imageFromServerURL(model.recipeImageUrl, placeHolder: nil)
            self.configureAccessibility()
        }
    }
    
    func configureAccessibility() {
        
        self.accessibilityIdentifier = "RecipeTableViewCell_\(self.tag)"
        self.recipeNameLabel?.accessibilityIdentifier = "RecipeName_\(self.tag)"
        self.recipeNameLabel?.isAccessibilityElement = true
        self.recipeNameLabel?.accessibilityTraits = UIAccessibilityTraits.staticText
        self.recipeNameLabel?.accessibilityValue = self.model?.recipeName
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        recipeImageView?.cancelImageDownloading() // NOTE: - Using AlamofireImage
        recipeImageView?.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
