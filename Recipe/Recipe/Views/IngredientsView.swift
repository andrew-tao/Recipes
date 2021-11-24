//
//  IngredientsView.swift
//  Recipe
//
//  Created by Andrew Tao on 6/10/21.
//

import SwiftUI

struct IngredientsView: View {

    @Binding var groups: [IngredientPair]
    
    init(_ groups: Binding<[IngredientPair]>) {
        self._groups = groups
    }
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Ingredients")) {
                    ForEach(groups) { ingredientPair in
                        let ingredient = binding(for: ingredientPair)
                        HStack {
                            TextField("Ingredient", text: ingredient.ingredient)
                            Spacer()
                            TextField("Amount", text: ingredient.measurement)
                        }
                    }.onDelete { indices in
                        groups.remove(atOffsets: indices)
                    }
                }
            }
            Button("Add Ingredient") {
                groups.append(IngredientPair())
            }
        }
    }
    
    private func binding(for ingredient: IngredientPair) -> Binding<IngredientPair> {
        guard let pairIndex = groups.firstIndex(where: { $0.id == ingredient.id }) else {
            fatalError("Can't find ingredient in array")
        }
        return $groups[pairIndex]
    }
}

struct IngredientPair: Identifiable, Codable {
    var ingredient: String
    var measurement: String
    var id: UUID
    
    init(ingredient: String = "", measurement: String = "", id: UUID = UUID()) {
        self.ingredient = ingredient
        self.measurement = measurement
        self.id = id
    }
    
    static func clone(_ arr: [IngredientPair]) -> [IngredientPair] {
        var ret = [IngredientPair]()
        for ingredientPair in arr {
            ret.append(ingredientPair)
        }
        return ret
    }
    
    static var sample = IngredientPair(ingredient: "Pineapple", measurement: "1")
}

struct IngredientsView_Previews: PreviewProvider {
    
    @State static var groups = IngredientPair.clone([IngredientPair.sample])
    
    static var previews: some View {
        
        IngredientsView($groups)
    }
 
}
