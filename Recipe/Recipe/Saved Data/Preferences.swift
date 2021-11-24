//
//  Preferences.swift
//  Recipe
//
//  Created by Andrew Tao on 6/8/21.
//

import SwiftUI
import Foundation

class Preferences: ObservableObject, Equatable {
    
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        } catch {
            fatalError("Can't find documents folder")
        }
    }
    private static var fileURL: URL {
        return documentsFolder.appendingPathComponent("preferences.data")
    }
    
    
    @Published var button = ColorPreferences()
    @Published var recipe = ColorPreferences()
    
    func load() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                return
            }
            guard let prefs = try? JSONDecoder().decode([ColorPreferences].self, from: data) else {
                fatalError("Can't load saved data")
            }
            DispatchQueue.main.async {
                self?.button = prefs[0]
                self?.recipe = prefs[1]
            }
        }
    }
    
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let buttonPref = self?.button else {
                fatalError("Self out of scope")
            }
            guard let recipePref = self?.recipe else {
                fatalError("Self out of scope")
            }
            let prefs = [buttonPref, recipePref]
            guard let data = try? JSONEncoder().encode(prefs) else {
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
    
    static func == (lhs: Preferences, rhs: Preferences) -> Bool {
        if lhs.button == rhs.button && lhs.recipe == rhs.recipe {
            return true
        }
        return false
    }
}

struct ColorPreferences: Codable, Equatable {
    var text = Color.white
    var color = Color.pink
    
    static func == (lhs: ColorPreferences, rhs: ColorPreferences) -> Bool {
        if lhs.color == rhs.color && lhs.text == rhs.text {
            return true
        }
        return false
    }
}


