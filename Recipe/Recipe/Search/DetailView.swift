//
//  DetailView.swift
//  Recipe
//
//  Created by Andrew Tao on 6/7/21.
//

import SwiftUI

struct DetailView: View {
    
    var meal: Meal?
    @State private var instructionsPresented = false
    @EnvironmentObject var preferences: Preferences
    @EnvironmentObject var savedRecipes: SavedRecipes
    
    static let defaultURL = "https://www.youtube.com/watch?v=dQw4w9WgXcQ" // :)
    
    init(meal: Meal?, save: Bool = true) {
        self.meal = meal
    }
    
    var body: some View {
        VStack {
            
            if meal?.image != nil {
                loadImage()
                    .resizable()
                    .scaledToFit()
            } else {
                RemoteImage(urlString: meal?.strMealThumb ?? "")
                    .scaledToFit()
            }
            
            List {
                Section(header: Text("Ingredients")) {
                    ForEach(meal?.groups ?? [IngredientPair]()) { ingredientPair in
                        HStack {
                            Text(ingredientPair.ingredient).frame(alignment: .leading)
                            Spacer()
                            Text(ingredientPair.measurement).frame(alignment: .trailing)
                        }
                    }
                }
            }
            .navigationTitle(meal?.strMeal ?? "")
            .fullScreenCover(isPresented: $instructionsPresented) {
                NavigationView {
                    ScrollView {
                        Text(meal?.strInstructions ?? "")
                            .padding()
                            .navigationTitle("Instructions")
                            .navigationBarItems(trailing: Button("Done") {
                                instructionsPresented = false
                            })
                    }
                }
            }
            
            HStack {
                Button("Instructions") {
                    instructionsPresented = true
                }.buttonStyle(PrettyButton(buttonPreferences: $preferences.button))
                
                Spacer()
                
                Link("Source", destination: URL(string: meal?.strSource ?? DetailView.defaultURL) ?? URL(string: DetailView.defaultURL)!).buttonStyle(PrettyButton(buttonPreferences: $preferences.button))
            }
            
        }.padding()
        .navigationBarItems(trailing: Button("Save Recipe") {
            guard meal != nil else { return }
            if !savedRecipes.recipes.contains(meal!){
                savedRecipes.recipes.append(meal!)
            } else {
                return
            }
            
            savedRecipes.save()
        })
    }
    
    func loadImage() -> Image {
        guard let data = meal?.image!.photo else {
            return Image(systemName: "photo")
        }
        guard let uiImage = UIImage(data: data) else {
            return Image(systemName: "photo")
        }
        return Image(uiImage: uiImage)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(meal: Meal.sample).environmentObject(Preferences()).environmentObject(SavedRecipes())
    }
}
