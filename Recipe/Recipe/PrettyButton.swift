//
//  PrettyButton.swift
//  Recipe
//
//  Created by Andrew Tao on 6/7/21.
//

import SwiftUI

struct PrettyButton: ButtonStyle {
    // @EnvironmentObject var preferences: Preferences
    // only works in simulators but not on my phone?
    
    @Binding var buttonPreferences: ColorPreferences
    
    init(buttonPreferences: Binding<ColorPreferences>) {
        self._buttonPreferences = buttonPreferences
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label.foregroundColor(buttonPreferences.text)
            Spacer()
        }
        .padding()
        .background(buttonPreferences.color.cornerRadius(8))
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct PrettyButton_Previews: PreviewProvider {
    
    @State static var preferences = Preferences()
    
    static var previews: some View {
        Button("Hi") {
            
        }.buttonStyle(PrettyButton(buttonPreferences: $preferences.button))
        .environmentObject(Preferences())
    }
}
