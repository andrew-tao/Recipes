//
//  RecipeApp.swift
//  Recipe
//
//  Created by Andrew Tao on 6/3/21.
//

import SwiftUI



@main
struct RecipeApp: App {
    @ObservedObject var preferences = Preferences()
    @ObservedObject var savedRecipes = SavedRecipes()
    
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    RecipeView()
                }.tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                
                NavigationView {
                    SavedView()
                }.tabItem {
                    Label("Saved", systemImage: "list.bullet")
                }
                
            }
            .environmentObject(preferences)
            .environmentObject(savedRecipes)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                preferences.load()
                savedRecipes.load()
            }
        }
    }
}
