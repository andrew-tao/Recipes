//
//  SavedView.swift
//  Recipe
//
//  Created by Andrew Tao on 6/10/21.
//

import SwiftUI

struct SavedView: View {
    
    @EnvironmentObject var savedRecipes: SavedRecipes
    @EnvironmentObject var preferences: Preferences
    @State var newMeal = Meal.Data()
    @State var isActive = false
    var body: some View {
        VStack {
            if savedRecipes.recipes.isEmpty {
                Text("No Saved Recipes!")
            }
            List {
                ForEach(savedRecipes.recipes) { meal in
                    NavigationLink(destination: EditView(meal: binding(for: meal))) {
                        HStack {
                            if meal.image != nil {
                                loadImage(meal: meal)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 70)
                            } else {
                                RemoteImage(urlString: meal.strMealThumb ?? "")
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 70)
                            }
                            Spacer()
                            Text(meal.strMeal ?? "Recipe not named")
                                .padding()
                        }
                        .padding()
                        .background(preferences.recipe.color)
                        .foregroundColor(preferences.recipe.text)
                        
                    }
                }.onDelete { indices in
                    
                    savedRecipes.recipes.remove(atOffsets: indices)
                    savedRecipes.save()
                }
                
                NavigationLink(destination: NewMealView(meal: $newMeal) {
                    savedRecipes.recipes.append(Meal(from: newMeal))
                    savedRecipes.save()
                    newMeal = Meal.Data()
                }) {
                    Text("Add New Recipe")
                }.isDetailLink(false)
            }
            .navigationTitle("Saved")
            
            
            
            Button("Delete All") {
                savedRecipes.recipes = [Meal]()
                savedRecipes.save()
            }.padding()
        }
    }
    
    func loadImage(meal: Meal) -> Image {
        guard let uiImage = UIImage(data: meal.image!.photo) else { return Image(systemName: "photo") }
        return Image(uiImage: uiImage)
    }
    
    private func binding(for meal: Meal) -> Binding<Meal> {
        guard let mealIndex = savedRecipes.recipes.firstIndex(where: { $0.id == meal.id }) else {
            fatalError("Can't find ingredient in array")
        }
        return $savedRecipes.recipes[mealIndex]
    }
}

struct SavedView_Previews: PreviewProvider {
    
    @ObservedObject static var savedRecipes = SavedRecipes(recipes: [Meal.sample, Meal.sample])
    
    static var previews: some View {
        NavigationView {
            SavedView()
        }.environmentObject(savedRecipes).environmentObject(Preferences())
    }
}
