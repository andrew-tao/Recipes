//
//  SearchBar.swift
//  Playground
//
//  Created by Andrew Tao on 6/8/21.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    let onCommit: () -> ()
    
    var body: some View {
        // Search view
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")

                TextField("search", text: $searchText, onEditingChanged: { _ in
                }, onCommit: {
                    onCommit()
                })
                .foregroundColor(.primary)
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)

        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    @State static var searchText = ""
    static var previews: some View {
        SearchBar(searchText: $searchText) {
            print("on commit")
        }
        Text(searchText)
    }
}
