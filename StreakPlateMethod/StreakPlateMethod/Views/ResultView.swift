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
    @State private var showingFinishAlert = false
    @State private var cultureName: String = ""
    
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                TextField("", text: $cultureName)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .frame(width: geometry.size.height * 0.5)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(radius: 2)
                    )
                
                
                HStack {
                    Spacer()
                    CanvasViewResult(canvasView: $canvasView, drawing: $drawing, backgroundColor: $backgroundColor)
                        .frame(width: canvasWidth, height: canvasHeight)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding()
                    Spacer()
                }
                Button {
                    path.append(.ARSceneView(microorganism: microorganism, cultureMedia: cultureMedia))
                } label: {
                    Text("Aumented Reality")
                        .styledTextButton()
                }

                
                Button(action: {
                    showingFinishAlert = true
                }) {
                    Text("Finish")
                        .styledTextButton()
                }
                Spacer()
            }
            .onAppear {
                canvasView.tool = PKInkingTool(.pen, color: .customGray, width: 5)
                backgroundColor = cultureMedia.color
                cultureName = microorganism.name
                //microorganismName = microorganism.name
            }
            .ignoresSafeArea(.keyboard)
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
            Button("Exit", role: .destructive) {
                path.removeLast(2)
                drawing.strokes.removeAll()
            }
        } message: {
            Text("If you go back now, all your progress will be lost.")
        }
        .alert("Finish the Experiment?", isPresented: $showingFinishAlert) {
            Button("Cancel", role: .destructive) {}
            Button("Finish", role: .cancel) {
                path.removeAll()
                drawing.strokes.removeAll()
            }
        } message: {
            Text("If you go finish now, you can't go back.")
        }
    }
}

#Preview {
    ResultView(path: .constant([]),
               
               microorganism: Microorganism(name: """
Saccharomyces 
cerevisiae
""", type: "", color: .red, textColor: .yeastText, image: "yeast"),
               
               cultureMedia: CultureMedia(name: "", type: "", color: .cyan, textColor: .textNutrient, image: ""),
               
               drawing: .constant(PKDrawing()),
               canvasView: PKCanvasView())
}
