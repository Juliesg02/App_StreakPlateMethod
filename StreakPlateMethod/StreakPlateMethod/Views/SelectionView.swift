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
    @State private var microSelected: Int? = nil
    @State private var cultureSelected: Int? = nil
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
                        ForEach(microorganisms.indices, id: \.self) { index in
                            let microorganism = microorganisms[index]
                            VStack {
                                Image(microorganism.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.07)
                                    .clipShape(.circle)
                                Text(microorganism.name)
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(microSelected == index ? Color(microorganism.color) :.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.top)
                                
                                Text(microorganism.type)
                                    .font(.caption)
                                    .foregroundColor(microSelected == index ? Color(microorganism.color) :.secondary)
                                    .italic()
                            }
                            .onTapGesture {
                                microSelected = index
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
                        ForEach(cultureMedias.indices, id: \.self) { index in
                            let media = cultureMedias[index]
                            VStack {
                                Image(media.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.07)
                                    .clipShape(.circle)
                                Text(media.name)
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(cultureSelected == index ? Color(media.color) :.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.top)
                                
                                Text(media.type)
                                    .font(.caption)
                                    .foregroundColor(cultureSelected == index ? Color(media.color) :.secondary)
                                    .italic()
                            }
                            .onTapGesture {
                                cultureSelected = index
                                updateCulture()
                            }
                        }
                    }
                    .padding()
                    
                    Button {
                        path.append(.labView(microorganism: microorganism, cultureMedia: cultureMedia))
                    } label: {
                        Text("Let's streak!")
                            .styledTextButton()
                    }
                    .disabled(microSelected == nil || cultureSelected == nil)
                    Spacer()
                }
                .padding()
            }
        
    }
    
    func updateMicroorganism() {
            if let index = microSelected {
                microorganism = microorganisms[index]
            } else {
                microorganism = microorganisms[0]
            }
        }
    
    func updateCulture() {
            if let index = cultureSelected {
                cultureMedia = cultureMedias[index]
            } else {
                cultureMedia = cultureMedias[0]
            }
        }
}

#Preview {
    SelectionView(path: .constant([]))
}
