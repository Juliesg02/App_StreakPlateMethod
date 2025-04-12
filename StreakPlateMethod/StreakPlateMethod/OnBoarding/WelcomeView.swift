//
//  WelcomeView.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 12/04/25.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    Spacer()
                    Text("Welcome, Microbiologist!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("""
                                🧪 You just stepped into a high-tech microbiology lab. Your mission? 
                                To isolate a microorganism critical for an experiment. But there's a catch—you need a pure culture, and the clock is ticking ⏳!
                                """)
                    .font(.title)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    NavigationLink (destination: IntroductionView()) {
                        Text("Let's begin!")
                            .styledTextButton()
                    }
                    
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                
            }
        }
                }
    }


#Preview {
    WelcomeView()
}
