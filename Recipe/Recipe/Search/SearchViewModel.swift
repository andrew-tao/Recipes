//
//  SearchViewModel.swift
//  Recipe
//
//  Created by Andrew Tao on 7/4/21.
//

import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
    @Published var results: Results?
    
    var searchText = "" { didSet {
            relay.send(searchText)
        }
    }
    private var relay = PassthroughSubject<String,Never>()
    private var cancellable: AnyCancellable?
  
    private init() {
        
    }
    
    public static func getViewModel() -> SearchViewModel {
        let model = SearchViewModel()
        model.cancellable = model.relay
            .throttle(for: 3.0, scheduler: RunLoop.main, latest: true)
            .sink { value in
                print(value)
                model.updateResults()
                print(model.results?.meals?[0].idMeal ?? "Wack")
        }
        return model
    }
    
    func updateResults() {
        results = searchText == "" ? nil : GetData.shared.search(byName: searchText)
    }
}
