//
//  ContentView.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 12/04/25.
//

import SwiftUI

enum Screen: Hashable {
    case welcomeView
    case introductionView
    case goalView
    case stepsView
}

struct ContentView: View {
    @State private var path: [Screen] = []
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                NavigationLink(destination: {}) {
                    Text("Intructions")
                        .styledTextButton()
                }
                Button {
                    path.append(.welcomeView)
                } label: {
                    Text("Go to Welcome View")
                }
            }
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .welcomeView: WelcomeView(path: $path)
                case .introductionView: IntroductionView(path: $path)
                case .goalView: GoalView(path: $path)
                case .stepsView: StepsView(path: $path)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
