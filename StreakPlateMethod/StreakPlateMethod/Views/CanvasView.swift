//
//  CanvasView.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 17/04/25.
//

import SwiftUI
import PencilKit


// A wrapper for PKCanvasView to integrate with SwiftUI
struct CanvasView: UIViewRepresentable {
    
    @Binding var canvasView: PKCanvasView // Binding to allow state updates from the parent view
    @Binding var drawing: PKDrawing // Binding the drawing
    
    @Binding var pathsInfo: [PathInfo] // Binding the strokesInfo
    //@Binding var isSampled: Bool
    //@Binding var microorganism: String
    //@Binding var isFlamed: Bool
    @Binding var backgroundColor: UIColor
    
    //@Binding var countingTime: Int
    //@Binding var animationIndex: Int
    
    
    // Creates and configures the PKCanvasView instance
    func makeUIView(context: Context) -> PKCanvasView {
        
        canvasView.drawingPolicy = .anyInput // Allows both finger and pencil inputs for drawing
        canvasView.delegate = context.coordinator // Set the coordinator as the canvas's delegate
        
        return canvasView
    }
    
    // Updates the PKCanvasView
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // No updates needed as of now
        if drawing != canvasView.drawing {
            canvasView.drawing = drawing
        }
    
        //BackgroundColor
        uiView.backgroundColor = backgroundColor
    }
    
    //Mark -coordinator
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: CanvasView
        
        init(parent: CanvasView) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            let currentDrawing = canvasView.drawing
            parent.drawing = currentDrawing
            
            
            // Detect new strokes
            if currentDrawing.strokes.count > parent.pathsInfo.count {
                if let newPath = currentDrawing.strokes.last?.path {
                    let newPathInfo = PathInfo(
                        path: newPath,
                        strokeIndex: currentDrawing.strokes.count - 1//,
//                        isSampled: parent.isSampled,
//                        microorganism: parent.microorganism,
//                        isFlamed: parent.isFlamed
                    )
                    parent.pathsInfo.append(newPathInfo)
                    print("New stroke added. Total strokesInfo count: \(parent.pathsInfo.count)")
                    
//                    if parent.isFlamed {
//                        parent.isFlamed = false
//                        parent.countingTime = 0
//                        parent.animationIndex = 0                    }
//                    
                }
            }
        }
    }
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}


struct PathInfo {
    let path: PKStrokePath
    let strokeIndex: Int
    //let isSampled: Bool
    //let microorganism: String
    //let isFlamed: Bool
}

struct PathInfoCut {
    let path: PKStrokePath
    let strokeIndex: Int
    let pathCutIndex: Int
    var touchedStrokeIndex: [Int]
    let isSampled: Bool
    //let microorganism: String
    let isFlamed: Bool
    var probabilityOfGrowth: Double?
    var nextTouchedStrokeIndex :Int?
}
