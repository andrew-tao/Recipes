//
//  RemoteImage.swift
//  Recipe
//
//  Created by Andrew Tao on 6/4/21.
//

import SwiftUI

struct RemoteImage: View {
    
    private enum LoadState {
        case loading, success, failure
    }
    
    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.loading
        
        init(urlString: String) {
            guard let url = URL(string: urlString) else {
                print("Invalid URL: \(urlString)")
                return
            }
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                if error == nil && data != nil {
                    self.data = data!
                    self.state = LoadState.success
                } else {
                    self.state = LoadState.failure
                }
                
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
            dataTask.resume()
        }
    }
    
    @StateObject private var loader: Loader
    var loading: Image
    var failure: Image
    
    var body: some View {
        selectImage()
            .resizable()
    }
    
    init(urlString: String, loading: Image = Image(systemName: "photo"), failure: Image = Image(systemName: "multiply.circle")) {
        _loader = StateObject(wrappedValue: Loader(urlString: urlString))
        self.loading = loading
        self.failure = failure
    }
    
    private func selectImage() -> Image {
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
        default:
            if let image = UIImage(data: loader.data) {
                return Image(uiImage: image)
            } else {
                return failure
            }
        }
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static let jsonURL = "https://www.themealdb.com//images//media//meals//wvpsxx1468256321.jpg"
    
    static var previews: some View {
        RemoteImage(urlString: jsonURL)
            .aspectRatio(contentMode: .fit)
            .frame(width: 200)
    }
}
