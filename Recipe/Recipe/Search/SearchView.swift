//
//  ContentView.swift
//  Recipe
//
//  Created by Andrew Tao on 6/3/21.
//

import SwiftUI
import Combine

struct SearchView: View {
    
    @EnvironmentObject var preferences: Preferences
    
    @ObservedObject private var viewModel = SearchViewModel.getViewModel()
    
    var body: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchText) {
                viewModel.updateResults()
            }
            
            List {
                ForEach(viewModel.results?.meals ?? [Meal]()) { meal in
                    NavigationLink(destination: DetailView(meal: meal)) {
                        Recipe(recipe: meal)
                    }
                }
            }
            .navigationTitle("Recipes")
            .navigationBarItems(trailing: NavigationLink(destination: PreferencesView().onDisappear {
                    preferences.save()
                }
            ) {
                    Image(systemName:"slider.horizontal.3")
                }.buttonStyle(PlainButtonStyle())
            )
            
        }
        .padding()
        .resignKeyboardOnDragGesture()
    }
}

struct RecipeView_Previews: PreviewProvider {
    @State static var preferences = Preferences()
    static var previews: some View {
        NavigationView {
            SearchView()
        }.environmentObject(Preferences())
    }
}

