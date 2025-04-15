//
//  SelectionView.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 15/04/25.
//

import SwiftUI

struct SelectionView: View {
    @Binding var path: [Screen]
    
    let layout = [
        GridItem(.fixed(200)),
        GridItem(.fixed(200)),
        GridItem(.fixed(200)),
        GridItem(.fixed(200)),
    ]
    @State private var microSelected = "None"
    @State private var cultureSelected = "None"
    @State private var microorganism: Microorganism = microorganisms[0]
    @State private var cultureMedia: CultureMedia = cultureMedias[0]
    
    
    
    var body: some View {
        
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    HStack {
                        Text("Select your Microorganism:")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    LazyVGrid (columns: layout) {
                        ForEach(microorganisms, id: \.name) { microorganism in
                            VStack {
                                Image(microorganism.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.07)
                                    .clipShape(.circle)
                                Text(microorganism.name)
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(microSelected == microorganism.name ? Color(microorganism.color) :.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.top)
                                
                                Text(microorganism.type)
                                    .font(.caption)
                                    .foregroundColor(microSelected == microorganism.name ? Color(microorganism.color) :.secondary)
                                    .italic()
                            }
                            .onTapGesture {
                                microSelected = microorganism.name
                                updateMicroorganism()
                            }
                        }
                    }
                    .padding()
                    
                    HStack {
                        Text("Select your Culture Media:")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    LazyVGrid(columns: layout) {
                        ForEach(cultureMedias, id: \.name) { media in
                            VStack {
                                Image(media.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.07)
                                    .clipShape(.circle)
                                Text(media.name)
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(cultureSelected == media.name ? Color(media.color) :.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.top)
                                
                                Text(media.type)
                                    .font(.caption)
                                    .foregroundColor(cultureSelected == media.name ? Color(media.color) :.secondary)
                                    .italic()
                            }
                            .onTapGesture {
                                cultureSelected = media.name
                                updateCulture()
                            }
                        }
                    }
                    .padding()
                    
                    NavigationLink(destination: {}) {
                        Text("Let's streak!")
                            .font(.title)
                            .padding()
                            .padding(.horizontal, 30)
                            .background(microSelected != "None" && cultureSelected != "None" ? Color.accentColor : Color.gray.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(microSelected == "None" || cultureSelected == "None")
                    
                    Spacer()
                }
                .padding()
            }
        
    }
    
    func updateMicroorganism() {
        microorganism = microorganisms.first{
            $0.name == microSelected
        } ??  Microorganism(name: """
                  Salmonella 
                  enterica
                  """,
                            type: "Bacteria", color: .salmonellaColor, image: "salmonella")
    }
    
    func updateCulture() {
        cultureMedia = cultureMedias.first{
            $0.name == cultureSelected
        } ??  CultureMedia(name: "Nutrient Agar",
                           type: "General", color: .cultureNutrient, image: "nutrientAgar")
    }
}

#Preview {
    SelectionView(path: .constant([]))
}
