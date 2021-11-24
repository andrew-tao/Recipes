//
//  RecipeView.swift
//  Recipe
//
//  Created by Andrew Tao on 6/4/21.
//

import SwiftUI

struct RecipeView: View {
    
    
    @EnvironmentObject var preferences: Preferences
    
    // the names are different to avoid similar names for confusion
    var recipe: Meal
    
    init(recipe: Meal) {
        self.recipe = recipe
    }
    
    var body: some View {
        HStack{
            if recipe.image != nil {
                loadImage()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 70)
            } else {
                RemoteImage(urlString: recipe.strMealThumb ?? "")
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 70)
            }
            Spacer()
            Text(recipe.strMeal ?? "Recipe not named")
                .padding()
        }
        .padding()
        .background(preferences.recipe.color)
        .foregroundColor(preferences.recipe.text)
    }
    
    func loadImage() -> Image {
        guard let uiImage = UIImage(data: recipe.image!.photo) else { return Image(systemName: "photo") }
        return Image(uiImage: uiImage)
    }
}


struct Recipe_Previews: PreviewProvider {
    @ObservedObject static var preferences = Preferences()
    static var previews: some View {
        RecipeView(recipe: Meal.sample)
            .previewLayout(.fixed(width: 400, height: 60))
            .environmentObject(Preferences())
    }
}
