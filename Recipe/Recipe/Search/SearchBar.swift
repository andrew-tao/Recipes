//
//  SearchBar.swift
//  Playground
//
//  Created by Andrew Tao on 6/8/21.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @State private var showCancelButton: Bool = false
    let onCommit: () -> ()
    let onClear: () -> ()
    
    init(searchText: Binding<String>, onCommit: @escaping () -> () = {}, onClear: @escaping () -> () = {}) {
        self._searchText = searchText
        self.onCommit = onCommit
        self.onClear = onClear
    }
    
    var body: some View {
        // Search view
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")

                TextField("search", text: $searchText, onEditingChanged: { _ in
                    self.showCancelButton = true
                }, onCommit: {
                    onCommit()
                })
                .foregroundColor(.primary)
                
                Button(action: {
                    self.searchText = ""
                    onClear()
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
            
            if showCancelButton  {
                Button("Cancel") {
                    UIApplication.shared.endEditing(true)
                    self.searchText = ""
                    self.showCancelButton = false
                    onClear()
                }
                .foregroundColor(Color(.systemBlue))
            }
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
