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
    case ARSceneView
}

struct ContentView: View {
    @State private var path: [Screen] = []
    @State private var drawing: PKDrawing = PKDrawing()
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button {
                    path.append(.selectionView)
                } label: {
                    Text("Start")
                        .styledTextButton()
                }
                Button {
                    path.append(.welcomeView)
                } label: {
                    Text("Go to Welcome View")
                }
                Button("Go to AR") {
                    path.append(.ARSceneView)
                }
            }
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .welcomeView: WelcomeView(path: $path)
                case .introductionView: IntroductionView(path: $path)
                case .goalView: GoalView(path: $path)
                case .stepsView: StepsView(path: $path)
                case .selectionView: SelectionView(path: $path)
                case .labView(let microorganism, let cultureMedia):
                    LabView(path: $path, microorganism: microorganism, cultureMedia: cultureMedia, drawing: $drawing)
                case .resultView(let microorganism, let cultureMedia): ResultView(path: $path, microorganism: microorganism, cultureMedia: cultureMedia, drawing: $drawing, canvasView: PKCanvasView())
                case .ARSceneView: ARSceneView()
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
