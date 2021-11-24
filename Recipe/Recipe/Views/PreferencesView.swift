//
//  PreferencesView.swift
//  Recipe
//
//  Created by Andrew Tao on 6/8/21.
//

import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var preferences: Preferences
    
    var body: some View {
        VStack {
            Text("Color Settings")
                .font(.largeTitle)
                .frame(alignment: .topLeading)
            VStack {
                ColorPicker("Button Color", selection: $preferences.button.color)
                ColorPicker("Button Text", selection: $preferences.button.text)
                ColorPicker("Recipe Color", selection: $preferences.recipe.color)
                ColorPicker("Recipe Text", selection: $preferences.recipe.text)
            }.padding()
            
            
            Spacer()
            
            VStack {
                Text("Sample Recipe Display")
                RecipeView(recipe: Meal.sample)
            }
            
            Spacer()
            
            HStack {
                Button("Reset to Default") {
                    preferences.button = ColorPreferences()
                    preferences.recipe = ColorPreferences()
                }.buttonStyle(PrettyButton(buttonPreferences: $preferences.button))
            }
        }
        .padding()
        .frame(alignment: .top)
    }
}

struct PreferencesView_Previews: PreviewProvider {
    @ObservedObject private static var preferences = Preferences()
    
    static var previews: some View {
        PreferencesView().environmentObject(Preferences())
    }
}
