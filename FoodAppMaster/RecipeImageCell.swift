//
//  RecipeImageCell.swift
//  Recipy
//
//  Created by Amaury Vidal on 19/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import Foundation
import UIKit

class RecipeImageCell: UITableViewCell {
    static let identifier = "RecipeImageCellIdentifier"
    
    @IBOutlet weak var recipeImageView: UIImageView!
    
    func configure(image: UIImage?) {
        recipeImageView.image = image
    }
}
