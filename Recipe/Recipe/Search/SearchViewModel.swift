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
    
    private static let byName = "https://www.themealdb.com/api/json/v1/1/search.php?s="
    static let byId = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
    
    @Published var searchText = "" { didSet {
            publisher.send(searchText)
        }
    }
    
    private var publisher = PassthroughSubject<String,Never>()
    private var cancellable: AnyCancellable?
  
    private init() {
        
    }
    
    public static func getViewModel() -> SearchViewModel {
        let model = SearchViewModel()
        model.cancellable = model.publisher
            .throttle(for: 3.0, scheduler: RunLoop.main, latest: true)
            .sink { value in
                print(value)
                model.updateResults()
        }
        return model
    }
    
    func updateResults() {
        
        if searchText == "" {
            results = nil
            return
        }
        
        let url = URL(string: SearchViewModel.byName + searchText)
        guard url != nil else {
            print("Url Issue")
            return
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            if error == nil && data != nil {
                
                // parse JSON
                let decoder = JSONDecoder()
                let jsonResults: JSONResults?
                do {
                    jsonResults = try decoder.decode(JSONResults.self, from: data!)
                } catch {
                    print("Error in JSON parsing")
                    jsonResults = nil
                }
                
                if (jsonResults == nil) {
                    return
                }
                
                DispatchQueue.main.async {
                    self.results = Results(fromJSON: jsonResults!)
                }
            }
        }
        dataTask.resume()
    }
}
