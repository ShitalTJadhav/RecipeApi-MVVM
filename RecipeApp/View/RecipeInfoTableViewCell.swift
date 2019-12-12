
//
//  RecipeDetailCell.swift
//  RecipeApp
//
//  Created by Tushar  Jadhav on 2019-01-18.
//  Copyright © 2019 Shital  Jadhav. All rights reserved.
//

import UIKit

class RecipeInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var publisherLabel: UILabel?
    @IBOutlet weak var socialRankLabel: UILabel?
    @IBOutlet weak var socialRankValueLabel: UILabel?
    
    var viewInstructionButtonBlock: ((_ urlString: String) -> Void)? = nil
    var viewOriginalButtonBlock: ((_ urlString: String) -> Void)? = nil
    
    var item: RecipeViewModelInfoItem? {
        didSet {
            guard let item = item else {
                return
            }
            
            self.publisherLabel?.text = item.publisher
            self.socialRankValueLabel?.text = item.socialRank
        }
    }
    
    @IBAction func didTapOnViewInstructionButton(sender: UIButton) {
        viewInstructionButtonBlock?(item?.instructionViewUrl ?? "")
    }
    
    @IBAction func didTapOnViewOriginalButton(sender: UIButton) {
        viewOriginalButtonBlock?(item?.recipeViewUrl ?? "")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class RecipeImageTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: AsyncImageView?

    var item: RecipeViewModelImageItem? {
        didSet {
            guard let item = item else {
                return
            }
            
            self.recipeImageView?.setImage(from: item.imageUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

class RecipeIngredientTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ingredientNameLabel: UILabel?

    var ingredient: String? {
        didSet {
            guard let ingredient = ingredient else {
                return
            }
            
            self.ingredientNameLabel?.text = ingredient
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
