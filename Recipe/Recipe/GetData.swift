//
//  GetData.swift
//  Recipe
//
//  Created by Andrew Tao on 6/3/21.
//

import Foundation

class GetData {
    
    static let shared = GetData()
    
    static let byName = "https://www.themealdb.com/api/json/v1/1/search.php?s="
    static let byId = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
    
    func search(byName name: String) -> Results? {
        return search(byUrlString: GetData.byName + name)
    }
    
    func search(byId id: String) -> Results? {
        return search(byUrlString: GetData.byId + id)
    }
    
    private func search(byUrlString urlString: String) -> Results? {
        let url = URL(string: urlString)
        guard url != nil else {
            return nil
        }
        
        let sem = DispatchSemaphore.init(value: 0)
        
        var results: Results?
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            defer { sem.signal() }
            
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
                
                results = Results(fromJSON: jsonResults!)
            }
        }
        dataTask.resume()
        sem.wait() // wait until results is updated to return
        return results
    }
}
