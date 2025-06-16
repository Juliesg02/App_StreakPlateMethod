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
    @StateObject private var petriStorage = PetriStorage()
    @StateObject private var motionManager = MotionManager()
    var body: some View {
        
        NavigationStack(path: $path) {
            ZStack {
                /*
                GeometryReader { geometry in
                    ZStack {
                        ForEach(motionManager.balls.indices, id: \.self ) { i in
                            ZStack {
                                Circle()
                                    .fill(motionManager.balls[i].color)
                                    .frame(width: 80, height: 80)
                                    .rotationEffect(motionManager.balls[i].rotationAngle)
                                    .offset(x: motionManager.balls[i].position.x,
                                            y: motionManager.balls[i].position.y)
                                Image(motionManager.balls[i].imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .rotationEffect(motionManager.balls[i].rotationAngle)
                                    .offset(x: motionManager.balls[i].position.x,
                                            y: motionManager.balls[i].position.y)
                            }
                            
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        motionManager.configure(screenSize: geometry.size, objectSize: CGSize(width: 80, height: 80))
                        motionManager.loadBalls(from: petriStorage.records)
                    }
                }
                 */
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
                case .resultView(let microorganism, let cultureMedia): ResultView(path: $path, microorganism: microorganism, cultureMedia: cultureMedia, drawing: $drawing, canvasView: PKCanvasView(), dotStrokes: $dotStrokes, storage: petriStorage)
                case .ARSceneView(let microorganism, let cultureMedia): ARSceneView( microorganism: microorganism, cultureMedia: cultureMedia, dotStrokes: $dotStrokes)
                    
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
