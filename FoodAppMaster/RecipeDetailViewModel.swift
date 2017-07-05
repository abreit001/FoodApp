//
//  RecipeDetailViewModel.swift
//  Recipy
//
//  Created by Amaury Vidal on 25/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import Foundation
import UIKit

struct RecipeDetailViewModel {
    private let apiClient = RecipeAPI.shared
    
    let recipe: Recipe
    
    var title: String {
        var title = recipe.title
        title = htmlToText(encodedString: title)!
        title = catchNames(encodedString: title)!
        return title
    }
    
    func htmlToText(encodedString: String) -> String? {
        let encodedData = encodedString.data(using: String.Encoding.utf8)!
        do {
            return try NSAttributedString(data: encodedData, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSNumber(value: String.Encoding.utf8.rawValue)], documentAttributes: nil).string
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func catchNames(encodedString: String) -> String? {
        var decodedString = encodedString
        var character = ""
        if let start = encodedString.range(of: "&"),
            let end  = encodedString.range(of: ";", range: start.upperBound..<encodedString.endIndex) {
            let code = encodedString[start.upperBound..<end.lowerBound]
            switch code {
            case "Nbsp" :
                character = " "
                break
            case "Amp" :
                character = "&"
                break
            case "Quot" :
                character = "\""
                break
            case "Lt" :
                character = "<"
                break
            case "Gt" :
                character = ">"
                break
            case "Iexcl" :
                character = "¡"
                break
            case "Copy" :
                character = "©"
                break
            case "Reg" :
                character = "®"
                break
            case "Iquest" :
                character = "¿"
                break
            default :
                break
            }
            decodedString = decodedString.replacingCharacters(in: start.lowerBound..<end.upperBound, with: character)
            
        }
        return decodedString
    }
    
    func image(completion: @escaping (UIImage?) -> Void) {
        apiClient.downloadImage(at: recipe.imageUrl, completion: completion)
    }
    
    func cancelImageDownload() {
        apiClient.cancelImageDownload()
    }
    
    var nbIngredients: Int {
        return recipe.ingredients?.count ?? 0
    }
    
    func ingredient(at index: Int) -> String? {
        return recipe.ingredients?[index]
    }
    
    func details(completion: @escaping (RecipeDetailViewModel) -> Void) {
        apiClient.recipe(id: recipe.recipeId) { (recipeDetails) in
            if let recipeDetails = recipeDetails {
                let vm = RecipeDetailViewModel(recipe: recipeDetails)
                completion(vm)
            }
        }
    }
}
