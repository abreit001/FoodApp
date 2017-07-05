//
//  RecipeListViewModel.swift
//  Recipy
//
//  Created by Amaury Vidal on 25/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import Foundation
import UIKit

struct RecipesListViewModel {
    private let apiClient = RecipeAPI.shared
    private let recipes: [Recipe]
    private let currentSearchPage: Int
    
    init(recipes: [Recipe] = [Recipe](), page: Int = 1) {
        self.recipes = recipes
        self.currentSearchPage = page
    }
    
    func recipe(at index: Int) -> Recipe? {
        return recipes[index]
    }
    
    func recipes(matching query: String, completion: @escaping ([Recipe]) -> Void) {
        apiClient.recipe(matching: query, page: currentSearchPage, completion: completion)
    }
    
    var nbRecipes: Int {
        return recipes.count
    }
    
    func title(at index: Int) -> String? {
        var title: String = (recipe(at: index)?.title)!.capitalized
        
        title = htmlToText(encodedString: title)!
        title = catchNames(encodedString: title)!
        
        /*var i = 0
        for codeUnit in title.utf8 {
            if !(codeUnit >= 64 && codeUnit <= 122)  {
                print(codeUnit)
                print(title[title.index(title.startIndex, offsetBy: i)])
            }
            i += 1
        }*/
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
    
    var noMoreResults: Bool {
        return !(recipes.count > 0 && recipes.count % 30 == 0)
    }
    
    func added(recipes: [Recipe]) -> RecipesListViewModel {
        let recipesConcat = self.recipes + recipes
        print(recipesConcat.count)
        return RecipesListViewModel(recipes: recipesConcat, page: currentSearchPage)
    }
    
    func incrementedPage() -> RecipesListViewModel {
        return RecipesListViewModel(recipes: recipes, page: currentSearchPage + 1)
    }
    
    func reseted() -> RecipesListViewModel {
        return RecipesListViewModel()
    }
}
