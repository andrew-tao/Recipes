//
//  ContentView.swift
//  Recipe
//
//  Created by Andrew Tao on 6/3/21.
//

import SwiftUI
import Combine

struct RecipeView: View {
    
    @EnvironmentObject var preferences: Preferences
    
    @State private var searchText = ""
    @State private var results: Results?
    
    private var relay = PassthroughSubject<String,Never>()
    private var throttledPublisher: AnyPublisher<String, Never>
  
    init() {
        self.throttledPublisher = relay
            .throttle(for: 1, scheduler: RunLoop.main, latest: true)
            .eraseToAnyPublisher()
    }
    
    var body: some View {
        VStack {
            SearchBar(searchText: $searchText) {
                results = searchText == "" ? nil : GetData.shared.search(byName: searchText)
            }.onChange(of: searchText) { value in
                relay.send(value)
            }
            
            List {
                ForEach(results?.meals ?? [Meal]()) { meal in
                    NavigationLink(destination: DetailView(meal: meal)) {
                        Recipe(recipe: meal)
                    }
                }.onReceive(throttledPublisher) { value in
                    results = value == "" ? nil : GetData.shared.search(byName: value)
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
    }
}

struct RecipeView_Previews: PreviewProvider {
    @State static var preferences = Preferences()
    static var previews: some View {
        NavigationView {
            RecipeView()
        }.environmentObject(Preferences())
    }
}

