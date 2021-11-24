//
//  Results.swift
//  Recipe
//
//  Created by Andrew Tao on 6/3/21.
//

import SwiftUI

struct Results {
    var meals: [Meal]?
    
    init(meals: [Meal]?) {
        self.meals = meals
    }
    
    init(fromJSON jsonResults: JSONResults) {
        guard jsonResults.meals != nil else {
            return
        }
        
        self.meals = [Meal]()
        for jsonMeal in jsonResults.meals! {
            self.meals!.append(Meal(fromJSON: jsonMeal))
        }
    }
}

extension Results {
    static var sample = Results(meals: [Meal.sample])
}

class Meal : Codable, ObservableObject, Equatable, Identifiable {
    
    struct Data {
        var image: UIImage? //(systemName: "photo")
        var name = ""
        var instructions = ""
        var groups = [IngredientPair]()
        var source = ""
        var strMealThumb: String?
    }
    
    let id: UUID
    var idMeal: String?
    var strMeal: String?
    var strInstructions: String?
    var strMealThumb: String?
    var groups: [IngredientPair]
    var strSource: String?
    var image: CodableImage?
    
    init(from data: Meal.Data) {
        self.id = UUID()
        self.strMeal = data.name
        self.strInstructions = data.instructions
        self.strMealThumb = data.strMealThumb
        self.strSource = data.source
        if data.image != nil {
            self.image = CodableImage(photo: data.image!)
        } else {
            self.image = nil
        }
        self.groups = data.groups
    }
    
    init(id: UUID = UUID(), idMeal: String?, strMeal: String?, strInstructions: String?, strMealThumb: String?, groups: [IngredientPair], strSource: String?) {
        self.id = id
        self.idMeal = idMeal
        self.strMeal = strMeal
        self.strInstructions = strInstructions
        self.strMealThumb = strMealThumb
        self.strSource = strSource
        self.groups = groups
    }
    
    init(fromJSON jsonMeal: JSONMeal, id: UUID = UUID()) {
        self.id = id
        self.idMeal = jsonMeal.idMeal
        self.strMeal = jsonMeal.strMeal
        self.strInstructions = jsonMeal.strInstructions
        self.strMealThumb = jsonMeal.strMealThumb
        if (Meal.isValid(jsonMeal.strSource)) {
            self.strSource = jsonMeal.strSource
        } else if (Meal.isValid(jsonMeal.strYoutube)) {
            self.strSource = jsonMeal.strYoutube
        } else {
            self.strSource = nil // no source :(
        }
        self.groups = [IngredientPair]()
        
        /* Unfortunately the TheMealDB returns all of the names and measurements for each of the 20
         * ingredients as individual parameters instead of a JSON array or object, and the
         * convention seems (there's no API doc) to be that whenever a recipe doesn't
         * require 20 ingredients, the remaining ingredients are just null. Creating an
         * entirely separate data structure to hold usable data from after parsing the
         * JSON seemed like the only way to feasibly do anything. */
        
        if (Meal.isValid(jsonMeal.strIngredient1, jsonMeal.strMeasure1)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient1!, measurement: jsonMeal.strMeasure1!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient2, jsonMeal.strMeasure2)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient2!, measurement: jsonMeal.strMeasure2!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient3, jsonMeal.strMeasure3)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient3!, measurement: jsonMeal.strMeasure3!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient4, jsonMeal.strMeasure4)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient4!, measurement: jsonMeal.strMeasure4!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient5, jsonMeal.strMeasure5)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient5!, measurement: jsonMeal.strMeasure5!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient6, jsonMeal.strMeasure6)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient6!, measurement: jsonMeal.strMeasure6!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient7, jsonMeal.strMeasure7)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient7!, measurement: jsonMeal.strMeasure7!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient8, jsonMeal.strMeasure8)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient8!, measurement: jsonMeal.strMeasure8!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient9, jsonMeal.strMeasure9)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient9!, measurement: jsonMeal.strMeasure9!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient10, jsonMeal.strMeasure10)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient10!, measurement: jsonMeal.strMeasure10!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient11, jsonMeal.strMeasure11)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient11!, measurement: jsonMeal.strMeasure11!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient12, jsonMeal.strMeasure12)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient12!, measurement: jsonMeal.strMeasure12!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient13, jsonMeal.strMeasure13)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient13!, measurement: jsonMeal.strMeasure13!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient14, jsonMeal.strMeasure14)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient14!, measurement: jsonMeal.strMeasure14!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient15, jsonMeal.strMeasure15)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient15!, measurement: jsonMeal.strMeasure15!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient16, jsonMeal.strMeasure16)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient16!, measurement: jsonMeal.strMeasure16!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient17, jsonMeal.strMeasure17)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient17!, measurement: jsonMeal.strMeasure17!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient18, jsonMeal.strMeasure18)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient18!, measurement: jsonMeal.strMeasure18!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient19, jsonMeal.strMeasure19)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient19!, measurement: jsonMeal.strMeasure19!))
        } else {
            return
        }
        
        if (Meal.isValid(jsonMeal.strIngredient20, jsonMeal.strMeasure20)) {
            groups.append(IngredientPair(ingredient: jsonMeal.strIngredient20!, measurement: jsonMeal.strMeasure20!))
        } else {
            return
        }
    }
    
    private static func isValid(_ ingredient: String?, _ measure: String?) -> Bool {
        if (isValid(ingredient) && isValid(measure)) {
            return true
        }
        return false
    }
    
    private static func isValid(_ string: String?) -> Bool {
        if (string != nil && string != "") {
            return true
        }
        return false
    }
    
    func data() -> Meal.Data {
        var data = Meal.Data()
        data.groups = self.groups
        if (self.image != nil) {
            data.image = UIImage(data: self.image!.photo)
        } else {
            data.image = nil
        }
        data.instructions = self.strInstructions ?? ""
        data.name = self.strMeal ?? ""
        data.source = self.strSource ?? ""
        data.strMealThumb = self.strMealThumb
        return data
    }
    
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        return lhs.idMeal == rhs.idMeal
    }
    
}

extension Meal {
    static var sample = Meal(idMeal: "52772", strMeal: "Teriyaki Chicken Casserole", strInstructions: "cook", strMealThumb: "https://www.themealdb.com//images//media//meals//wvpsxx1468256321.jpg", groups: [IngredientPair.sample], strSource: "www.youtube.com")
}
