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
        
        title = catchNames(encodedString: title)!
        do {
            try title = title.convertHtmlSymbols()!
        }
        catch {}

        return title
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
            case "#160" :
                character = " "
                break
            case "Amp" :
                character = "&"
                break
            case "#38" :
                character = "&"
                break
            case "Quot" :
                character = "\""
                break
            case "#34" :
                character = "\""
                break
            case "Lt" :
                character = "<"
                break
            case "#60" :
                character = "<"
                break
            case "Gt" :
                character = ">"
                break
            case "#62" :
                character = ">"
                break
            case "Iexcl" :
                character = "¡"
                break
            case "#161" :
                character = "¡"
                break
            case "Copy" :
                character = "©"
                break
            case "#169" :
                character = "©"
                break
            case "Reg" :
                character = "®"
                break
            case "#174" :
                character = "®"
                break
            case "Iquest" :
                character = "¿"
                break
            case "#191" :
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
    
    func recipe(id: String, completion: @escaping (Recipe?) -> Void) {
        apiClient.recipe(id: id, completion: completion)
        
    }
    
    func incrementedPage() -> RecipesListViewModel {
        return RecipesListViewModel(recipes: recipes, page: currentSearchPage + 1)
    }
    
    func reseted() -> RecipesListViewModel {
        return RecipesListViewModel()
    }
}

extension String {
    func convertHtmlSymbols() throws -> String? {
        guard let data = data(using: .utf8) else { return nil }
        
        return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil).string
    }
}
