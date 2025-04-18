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
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Button(action: {}) {
                    Text("Rotate")
                        .styledTextButton()
                }
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Text("Incubate")
                            .styledTextButton()
                    }
                    CanvasView(canvasView: $canvasView, drawing: $drawing, pathsInfo: $pathsInfo, backgroundColor: $backgroundColor)
                        .frame(width: geometry.size.height * 0.6, height: geometry.size.height * 0.6)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding()
                        //.rotationEffect(.degrees(rotation))
                    Button(action: {}) {
                        Text("Incubate")
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
}

#Preview {
    LabView(path: .constant([]),
            microorganism: Microorganism(name: """
Saccharomyces 
cerevisiae
""", type: "", color: .cyan, image: ""),
            cultureMedia: CultureMedia(name: "", type: "", color: .cyan, image: ""))
}
