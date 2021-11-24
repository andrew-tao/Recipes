//
//  NewRecipeView.swift
//  Recipe
//
//  Created by Andrew Tao on 6/10/21.
//

import SwiftUI

struct NewMealView: View {
    @EnvironmentObject var preferences: Preferences
    @Binding var meal: Meal.Data
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var showInstructions = false
    let saveAction: () -> Void
    
    @State private var newIngredient = ""
    @State private var newAmount = ""
    @State private var showSaveConfirm = false
    
    init(meal: Binding<Meal.Data>, saveAction: @escaping () -> Void) {
        self._meal = meal
        self.saveAction = saveAction
        
    }
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.secondary)
                
                if meal.image != nil {
                    NewMealView.loadImage(from: meal)?
                        .resizable()
                        .scaledToFit()
                } else if meal.strMealThumb != nil {
                    RemoteImage(urlString: meal.strMealThumb!)
                        .scaledToFit()
                } else {
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }.onTapGesture {
                self.showingImagePicker = true
            }.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            
            TextField("Name", text: $meal.name).font(.title)
            TextField("Source", text: $meal.source)
            VStack {
                List {
                    Section(header: Text("Ingredients")) {
                        ForEach(meal.groups) { ingredientPair in
                            HStack {
                                Text(ingredientPair.ingredient).frame(alignment: .leading)
                                Spacer()
                                Text(ingredientPair.measurement).frame(alignment: .trailing)
                            }
                        }.onDelete { indices in
                            meal.groups.remove(atOffsets: indices)
                        }
                        HStack {
                            TextField("Ingredient", text: $newIngredient)
                            TextField("Amount", text: $newAmount)
                            Button(action: {
                                withAnimation {
                                    meal.groups.append(IngredientPair(ingredient: newIngredient, measurement: newAmount))
                                    newIngredient = ""
                                    newAmount = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                            }
                            .disabled(newIngredient.isEmpty || newAmount.isEmpty)
                        }
                    }
                }
            }
            .navigationTitle("Editing " + $meal.name.wrappedValue)
            .fullScreenCover(isPresented: $showInstructions) {
                NavigationView {
                    ScrollView {
                        ZStack {
                            TextEditor(text: $meal.instructions)
                                .navigationTitle("Edit Instructions")
                                .navigationBarItems(trailing: Button("Done") {
                                    showInstructions = false
                                })
                            Text(meal.instructions).opacity(0).padding(.all, 8)
                        }.shadow(radius: 1)
                        .padding()
                    }
                }
            }
            
            HStack {
                Button("Edit Instructions") {
                    showInstructions = true
                }.buttonStyle(PrettyButton(buttonPreferences: $preferences.button))
            }
            
            Button("Save Changes") {
                if !newIngredient.isEmpty || !newAmount.isEmpty {
                    showSaveConfirm = true
                } else {
                    saveAction()
                    meal.image = nil
                    self.mode.wrappedValue.dismiss()
                }
            }
        }.padding()
        .alert(isPresented:$showSaveConfirm) {
                    Alert(
                        title: Text("You have an unadded ingredient"),
                        message: Text("(Don't forget to press the \"+\" button)"),
                        primaryButton: .default(Text("Save anyways")) {
                            saveAction()
                            meal.image = nil
                            self.mode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
    }
    
    private func binding(for ingredient: IngredientPair) -> Binding<IngredientPair> {
        guard let pairIndex = meal.groups.firstIndex(where: { $0.id == ingredient.id }) else {
            fatalError("Can't find ingredient in array")
        }
        return $meal.groups[pairIndex]
    }
    
    func loadImage() {
        guard let inputImage = inputImage else {
            print("No Input Image")
            return
        }
        meal.image = inputImage
    }
    
    private static func loadImage(from meal: Meal.Data) -> Image? {
        guard meal.image != nil else { return nil }
        return Image(uiImage: meal.image!)
    }
    
}

struct NewRecipeView_Previews: PreviewProvider {
    
    @State static var data = Meal.sample.data()
    
    static var previews: some View {
        NewMealView(meal: $data) {
            
        }.environmentObject(Preferences())
    }
}
