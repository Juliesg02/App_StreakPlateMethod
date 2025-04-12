//
//  StepsView.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 12/04/25.
//

import SwiftUI

struct GoalView: View {
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    Image("AllStreaks")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.3)
                    
                    Text("""
                    Four-quadrant streak method
                    """)
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .italic()
                    .foregroundStyle(.secondary)
                    .padding(.top)
                    
                }
                .padding(.leading)
                
                VStack {
                    Spacer()
                    Spacer()
                    
                    Text("Your Goal: ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("""
                                Isolate a single bacterial colony using the four-quadrant streak method.
                                
                                The challenge? You must streak each quadrant carefully, reducing bacterial concentration step by step. A steady hand and the right technique will determine your success!
                                """ )
                    .font(.title)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    NavigationLink (destination: {}) {
                        Text("Continue")
                            .font(.title)
                            .padding()
                            .padding(.horizontal, 30)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    Spacer()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

#Preview {
    GoalView()
}
