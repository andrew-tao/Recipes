//
//  CodableImage.swift
//  Recipe
//
//  Created by Andrew Tao on 6/10/21.
//

import SwiftUI

public struct CodableImage: Codable {
    
    public let photo: Data
    
    public init(photo: UIImage) {
        self.photo = photo.pngData()!
    }
    
}
