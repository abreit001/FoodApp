//
//  Recipe.swift
//  Recipy
//
//  Created by Amaury Vidal on 19/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import Foundation
import UIKit

struct Recipe {
    let recipeId: String
    let imageUrl: URL
    let sourceUrl: URL
    let f2fUrl: URL
    let title: String
    let publisher: String
    let publisherUrl: URL
    let socialRank: Double
    let ingredients: [String]?  // Only present on the Search requests
    let page: Int?              // Only on the Get requests
}

// Recipe JSON Parsing
extension Recipe {
    init?(json: [String: Any]) {
        // First we make sure that the non-optional fields are present in the Json
        // else the initialisation fails
        guard
            let recipeId = json["recipe_id"] as? String,
            let imageUrlRaw = json["image_url"] as? String,
            let sourceUrlRaw = json["source_url"] as? String,
            let f2fUrlRaw = json["f2f_url"] as? String,
            let title = json["title"] as? String,
            let publisher = json["publisher"] as? String,
            let publisherUrlRaw = json["publisher_url"] as? String,
            let socialRank = json["social_rank"] as? Double
            else {
                return nil
        }
        
        
        // We try to create URL from the string retreived
        // else the initialisation fails
        guard
            let imageUrl = URL(string: imageUrlRaw),
            let sourceUrl = URL(string: sourceUrlRaw),
            let f2fUrl = URL(string: f2fUrlRaw),
            let publisherUrl = URL(string: publisherUrlRaw)
            else {
                return nil
        }
        
        // We assign the retreived value and the optionals one to the our recipe
        self.recipeId = recipeId
        self.imageUrl = imageUrl
        self.sourceUrl = sourceUrl
        self.f2fUrl = f2fUrl
        self.title = title
        self.publisher = publisher
        self.publisherUrl = publisherUrl
        self.socialRank = socialRank
        self.ingredients = json["ingredients"] as? [String]
        self.page = json["page"] as? Int
    }
}
