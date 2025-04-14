//
//  IntroductionView.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 12/04/25.
//

import SwiftUI

struct IntroductionView: View {
    @Binding var path: [Screen]
    var body: some View {
            GeometryReader { geometry in
                HStack {
                    VStack {
                        Image("Incubation")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.3)
                        
                        Text("""
                            Petri Plate with Nutrient-rich Agar
                            and Microorganisms
                            """)
                        .font(.title2)
                        .italic()
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    }
                    .padding(.leading)
                    
                    VStack {
                        Spacer()
                        Spacer()
                        
                        Text("The Art of Isolation")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("""
                                    Microbiologists use the streak plate method to separate bacteria into individual colonies. By streaking a sample across a nutrient-rich agar plate, we gradually thin out the cells to obtain single colonies.
                                    """ )
                        .font(.title)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.vertical)
                        .padding(.horizontal, 30)
                        
                        Spacer()
                        
                        Button {
                            path.append(.goalView)
                        } label: {
                            Text("Continue")
                                .styledTextButton()
                        }
                        Spacer()
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
}

#Preview {
    IntroductionView(path: .constant([]))
}
