//
//  ContentView.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 12/04/25.
//

import SwiftUI
import PencilKit

enum Screen: Hashable {
    case welcomeView
    case introductionView
    case goalView
    case stepsView
    case selectionView
    case labView(microorganism: Microorganism, cultureMedia: CultureMedia)
    case resultView(microorganism: Microorganism, cultureMedia: CultureMedia)
    case ARSceneView(microorganism: Microorganism, cultureMedia: CultureMedia)
}

struct ContentView: View {
    @State private var OnBoarding: Bool = UserDefaults.standard.bool(forKey: "OnBoarding")
    @State private var path: [Screen] = []
    @State private var drawing: PKDrawing = PKDrawing()
    @State private var dotStrokes: [PKStroke] = []
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Spacer()
                Spacer()
                Text("StreakLab!")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Button {
                    path.append(.selectionView)
                } label: {
                    Text("Start")
                        .styledTextButton()
                }
                .padding()
                Button {
                    path.append(.welcomeView)
                } label: {
                    Text("Instructions")
                }
                Spacer()
            }
            .onAppear {
                if !OnBoarding {
                    path.append(.welcomeView)
                }
            }
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .welcomeView: WelcomeView(path: $path)
                case .introductionView: IntroductionView(path: $path)
                case .goalView: GoalView(path: $path)
                case .stepsView: StepsView(onBoarding: $OnBoarding, path: $path)
                case .selectionView: SelectionView(path: $path)
                case .labView(let microorganism, let cultureMedia):
                    LabView(path: $path, microorganism: microorganism, cultureMedia: cultureMedia, drawing: $drawing, dotStrokes: $dotStrokes)
                case .resultView(let microorganism, let cultureMedia): ResultView(path: $path, microorganism: microorganism, cultureMedia: cultureMedia, drawing: $drawing, canvasView: PKCanvasView(), dotStrokes: $dotStrokes)
                case .ARSceneView(let microorganism, let cultureMedia): ARSceneView( microorganism: microorganism, cultureMedia: cultureMedia, dotStrokes: $dotStrokes)
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
