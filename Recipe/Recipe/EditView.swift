//
//  DetailView.swift
//  Recipe
//
//  Created by Andrew Tao on 6/7/21.
//

import SwiftUI

struct EditView: View {
    
    @Binding var meal: Meal
    @State var data = Meal.Data()
    @State private var instructionsPresented = false
    @EnvironmentObject var preferences: Preferences
    @EnvironmentObject var savedRecipes: SavedRecipes
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    
    static let defaultURL = "https://www.youtube.com/watch?v=dQw4w9WgXcQ" // :)
    
    init(meal: Binding<Meal>) {
        self._meal = meal
        
    }
    
    var body: some View {
        VStack {
            
            if meal.image != nil {
                loadImage()
                    .resizable()
                    .scaledToFit()
            } else {
                RemoteImage(urlString: meal.strMealThumb ?? "")
                    .scaledToFit()
            }
            
            List {
                Section(header: Text("Ingredients")) {
                    
                    ForEach(meal.groups) { ingredientPair in
                        HStack {
                            Text(ingredientPair.ingredient).frame(alignment: .leading)
                            Spacer()
                            Text(ingredientPair.measurement).frame(alignment: .trailing)
                        }
                    }
                }
            }
            .navigationTitle(meal.strMeal ?? "")
            .fullScreenCover(isPresented: $instructionsPresented) {
                NavigationView {
                    ScrollView {
                        Text(meal.strInstructions ?? "")
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
                
                Link("Source", destination: URL(string: meal.strSource ?? DetailView.defaultURL) ?? URL(string: DetailView.defaultURL)!).buttonStyle(PrettyButton(buttonPreferences: $preferences.button))
            }
            NavigationLink("Edit Recipe", destination: NewMealView(meal: $data, saveAction: {
                meal = Meal(from: data)
                savedRecipes.save()
            }).onAppear{
                data = meal.data()
            }/*.onDisappear {
                data = meal.data()
            }*/)//.buttonStyle(PrettyButton(buttonPreferences: $preferences.button))
        }.padding()
                            
            /* Button("Edit") {
            savedRecipes.recipes.removeAll(where: {$0.id == meal.id})
            self.mode.wrappedValue.dismiss()
            savedRecipes.save()
        }*/
    }
    
    func loadImage() -> Image {
        guard let data = meal.image?.photo else {
            return Image(systemName: "photo")
        }
        guard let uiImage = UIImage(data: data) else {
            return Image(systemName: "photo")
        }
        return Image(uiImage: uiImage)
    }
}

struct EditView_Previews: PreviewProvider {
    @State static var meal = Meal.sample
    static var previews: some View {
        NavigationView {
            EditView(meal: $meal).environmentObject(Preferences()).environmentObject(SavedRecipes())
        }
    }
}
