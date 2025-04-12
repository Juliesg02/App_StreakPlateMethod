//
//  StepsView.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 12/04/25.
//

import SwiftUI


struct InstructionsView: View {
    let instruction: Instruction
    let geometry: GeometryProxy
    var body: some View {
        
        HStack {
            VStack {
                Image(instruction.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.3)
                Text(instruction.description)
                    .font(.title2)
                    .italic()
                    .foregroundStyle(.secondary)
                    .padding(.top)
                
            }
            .padding(.leading, geometry.size.width * 0.05)
            
            VStack {
                Spacer()
                Spacer()
                
                Text(instruction.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(instruction.explication)
                    .font(.title)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                    .padding(.horizontal, 30)
                
                if instruction.secondImage != nil && instruction.secondExplication != nil{
                    HStack {
                        Image(instruction.secondImage ?? "")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.05)
                        Text(instruction.secondExplication ?? "")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.vertical)
                            .padding(.trailing)
                    }
                }
                Spacer()
                Spacer()
                
            }
        }
    }
}



struct StepsView: View {
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.accentColor)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.secondary)
    }
    var body: some View {
        GeometryReader { geometry in
            TabView {
                ForEach(Instructions, id: \.title) { instruction in
                    InstructionsView(instruction: instruction, geometry: geometry)
                }
                VStack {
                    Text("Step 10: Let's go to the Lab!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    
                    Image("Incubation")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.3)
                    Text("A Petri dish after incubation.")
                        .font(.title2)
                        .italic()
                        .foregroundStyle(.secondary)
                        .padding(.vertical)
                    
                    NavigationLink (destination: {}) {
                        Text("Let's go!")
                            .font(.title)
                            .padding()
                            .padding(.horizontal, 30)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.top)
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

        }
    }
}



#Preview {
    StepsView()
}
