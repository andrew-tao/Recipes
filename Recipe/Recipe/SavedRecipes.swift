//
//  SavedRecipes.swift
//  Recipe
//
//  Created by Andrew Tao on 6/10/21.
//

import Foundation

class SavedRecipes: ObservableObject {
    @Published var recipes = [Meal]()
    
    init(recipes: [Meal] = [Meal]()) {
        self.recipes = recipes
    }
    
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        } catch {
            fatalError("Can't find documents folder")
        }
    }
    private static var fileURL: URL {
        return documentsFolder.appendingPathComponent("savedRecipes.data")
    }
    
    func load() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                return
            }
            guard let recipes = try? JSONDecoder().decode([Meal].self, from: data) else {
                // fatalError("Can't load saved data")
                return
            }
            DispatchQueue.main.async {
                self?.recipes = recipes
            }
        }
    }
    
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let recipes = self?.recipes else {
                fatalError("Self out of scope")
            }
            guard let data = try? JSONEncoder().encode(recipes) else {
                fatalError("Error encoding data")
            }
            do {
                let outfile = Self.fileURL
                try data.write(to: outfile)
            } catch {
                fatalError("Can't write to file")
            }
        }
    }
    
}
