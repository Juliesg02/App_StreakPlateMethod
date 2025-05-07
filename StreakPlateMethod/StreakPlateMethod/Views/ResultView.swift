//
//  ResultView.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 29/04/25.
//

import SwiftUI
import PencilKit

struct ResultView: View {
    @Binding var path: [Screen]
    var microorganism: Microorganism
    var cultureMedia: CultureMedia
    @Binding var drawing: PKDrawing
    @State var canvasView: PKCanvasView
    @State private var backgroundColor: UIColor = .white
    @State private var showingBackAlert = false
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    CanvasViewResult(canvasView: $canvasView, drawing: $drawing, backgroundColor: $backgroundColor)
                        .frame(width: geometry.size.height * 0.6, height: geometry.size.height * 0.6)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding()
                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear {
            canvasView.tool = PKInkingTool(.pen, color: .customGray, width: 5)
            backgroundColor = cultureMedia.color
            //microorganismName = microorganism.name
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showingBackAlert = true
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .fontWeight(.semibold)
                        Text("Back")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)

        .alert("Exit the Experiment?", isPresented: $showingBackAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Exit", role: .destructive) {
                path.removeLast(2)
                drawing.strokes.removeAll()
            }
        } message: {
            Text("If you go back now, all your progress will be lost.")
        }
    }
}

#Preview {
    ResultView(path: .constant([]),
               
               microorganism: Microorganism(name: """
Saccharomyces 
cerevisiae
""", type: "", color: .red, image: "yeast"),
               
               cultureMedia: CultureMedia(name: "", type: "", color: .cyan, image: ""),
               
               drawing: .constant(PKDrawing()),
               canvasView: PKCanvasView())
}
