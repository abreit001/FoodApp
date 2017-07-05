//
//  RecipeDetailCell.swift
//  Recipy
//
//  Created by Amaury Vidal on 19/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import Foundation
import UIKit

protocol URLActionDelegate: UIWebViewDelegate {
    func showUrl(url: URL?)
}

class RecipeDetailCell: UITableViewCell {
    static let identifier = "RecipeDetailCellIdentifier"
    
    @IBOutlet weak var instructionButton: UIButton!
    @IBOutlet weak var originalButton: UIButton!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    private weak var delegate: URLActionDelegate?
    private var instructionURL: URL?
    private var originalURL: URL?
    
    func configure(recipe: Recipe, delegate: URLActionDelegate) {
        self.delegate = delegate
        publisherLabel.text = recipe.publisher
        rankLabel.text = "Social rank: \(round(recipe.socialRank))"
        instructionURL = recipe.f2fUrl
        originalURL = recipe.sourceUrl
    }
    
    @IBAction func viewInstruction(_ sender: UIButton) {
        delegate?.showUrl(url: instructionURL)
    }
    
    @IBAction func viewOriginal(_ sender: UIButton) {
        delegate?.showUrl(url: originalURL)
    }
}
