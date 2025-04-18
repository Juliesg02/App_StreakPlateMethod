//
//  LabView.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 17/04/25.
//

import SwiftUI
import PencilKit

struct LabView: View {
    @Binding var path: [Screen]
    let microorganism: Microorganism
    let cultureMedia: CultureMedia
    
    //Canvas
    @State private var canvasView = PKCanvasView()
    @State private var drawing = PKDrawing()
    //    @State private var toolPicker = PKToolPicker()
    @State private var backgroundColor: UIColor = .white
    
    //Stroke info
    @State private var pathsInfo: [PathInfo] = []
    @State private var isSampled: Bool = false
    
    //Buttons
    @State private var rotation = 0.0
    @State private var rotationIcon = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Button(action: {withAnimation {
                    rotation -= 90
                    rotationIcon -= 360
                }}) {
                    Image("noventa")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.05)
                        .rotationEffect(.degrees(rotationIcon))
                }
                HStack {
                    Spacer()
                    Button(action: takeSample) {
                        VStack {
                            Text(isSampled ? "Sampled" : "    ")
                                .font(.title)
                                .bold()
                                .foregroundStyle(Color(microorganism.color))
                            
                            Image(microorganism.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.15)
                            
                            Text("Tab to sample")
                            .font(.title3)
                            .foregroundStyle(.gray)
                        }
                        .animation(.default, value: isSampled)
                    }
                    CanvasView(canvasView: $canvasView, drawing: $drawing, pathsInfo: $pathsInfo, backgroundColor: $backgroundColor)
                        .frame(width: geometry.size.height * 0.6, height: geometry.size.height * 0.6)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding()
                        .rotationEffect(.degrees(rotation))
                    Button(action: {}) {
                        Text("Flame")
                            .styledTextButton()
                    }
                    Spacer()
                }
                Button(action: {}) {
                    Text("Incubate")
                        .styledTextButton()
                }
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        //
                    } label: {
                        Text("Cheat Sheet")
                            .foregroundStyle(Color.accentColor)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        //
                    } label: {
                        Text("Restart")
                            .foregroundStyle(.red)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        //
                    } label: {
                        Text("About")
                            .foregroundStyle(Color.accentColor)
                    }
                }
            }
        }
        .onAppear {
            canvasView.tool = PKInkingTool(.pen, color: .customGray, width: 5)
            backgroundColor = cultureMedia.color
            //microorganismName = microorganism.name
        }
        
        
    }
    func takeSample() {
        isSampled = true
        //recetFlame()
    }
}

#Preview {
    LabView(path: .constant([]),
            microorganism: Microorganism(name: """
Saccharomyces 
cerevisiae
""", type: "", color: .cyan, image: "yeast"),
            cultureMedia: CultureMedia(name: "", type: "", color: .cyan, image: ""))
}
