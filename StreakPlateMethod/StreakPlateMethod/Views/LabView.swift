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
    @Binding var drawing: PKDrawing
    //    @State private var toolPicker = PKToolPicker()
    @State private var backgroundColor: UIColor = .white
    
    //Stroke info
    @State private var pathsInfo: [PathInfo] = []
    @State private var isSampled: Bool = false
    @State private var isFlamed: Bool = false
    
    //Buttons
    @State private var rotation = 0.0
    @State private var rotationIcon = 0.0
    
    //Alerts
    @State private var showingRestartAlert = false
    @State private var showingBackAlert = false
    @State private var showingIncubate = false
    @State private var showingNoStreak = false

    //Analisis
    @State private var segments: [Segment] = []

    
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
                            .foregroundStyle(Color.secondary)
                        }
                        .animation(.default, value: isSampled)
                    }
                    CanvasView(canvasView: $canvasView, drawing: $drawing, pathsInfo: $pathsInfo, isSampled: $isSampled, isFlamed: $isFlamed, backgroundColor: $backgroundColor)
                        .frame(width: canvasWidth, height: canvasHeight)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding()
                        .rotationEffect(.degrees(rotation))
                    
                    ButtonFlame(isFlamed: $isFlamed, isSample: $isSampled, width: geometry.size.width * 0.15)
                    Spacer()
                }
                Button(action: {
                    print(pathsInfo)
                    if drawing.strokes.count > 0 {
                        showingIncubate = true
                    } else {
                        showingNoStreak = true
                    }
                }) {
                    Text("Incubate")
                        .styledTextButton()
                }
                Button("Delete", action: {showingRestartAlert = true})
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
                    showingRestartAlert = true
                } label: {
                    Text("Restart")
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("Exit the Experiment?", isPresented: $showingBackAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Exit", role: .destructive) {
                path.removeLast()
                drawing.strokes.removeAll()
            }
        } message: {
            Text("If you go back now, all your progress will be lost.")
        }
        
        .alert("Restart the Experiment", isPresented: $showingRestartAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Restart", role: .destructive) {clearCanvas()}
        } message: {
            Text("Do you need a new petri dish?")
        }
        
        .alert("The last step!", isPresented: $showingIncubate) {
            Button("Cancel", role: .destructive) {}
            Button("Incubate", role: .cancel) {
                incubate()
            }
        } message: {
            Text("Do you want to incubate your petri dish?")
        }
        
        .alert("Empty petri dish", isPresented: $showingNoStreak) {
            Button("Ok") {}
        } message: {
            Text("Your petri dish needs to have at least one stroke.")
        }
        
        
    }
    func takeSample() {
        isSampled = true
        isFlamed = false
        //recetFlame()
    }
    func clearCanvas() {
        drawing = PKDrawing() //canvasView.drawing = PKDrawing()
        pathsInfo.removeAll()
        print ("Strokes removed. Stroke count: \(pathsInfo.count)")
        
        isSampled = false
        isFlamed = false
        segments.removeAll()
    }
    func incubate() {
        print("Incubation started")
        
        //Creation of Segments
        for strokeIndex in drawing.strokes.indices {
            var idNumber = 0
            let path = drawing.strokes[strokeIndex].path
            for parametricValue in 0..<(path.count-1)  {
                let newSegment = Segment(strokeIndex: strokeIndex,
                                         id: UUID(),
                                         idNumber: idNumber,
                                         points:
                                            [path.interpolatedPoint(at: CGFloat(parametricValue)).location,
                                             path.interpolatedPoint(at: CGFloat(parametricValue + 1)).location] )
                idNumber += 1
                segments.append(newSegment)
            }
        }
        //Creation of Events
        let events = creationOfEvents(segments: segments)
        //Init of Status Class
        let status = Status(segments: segments, events: events)
        //Init of IntersectedPoints
        let intersectedPoints = IntersectedPoints(points: [])
        
        //Recognition of intersections
        while !status.events.isEmpty {
            let point = status.events.removeFirst()
            handleEvent(point: point, status: status,intersectedPoints: intersectedPoints)
        }
        
        print(intersectedPoints.points)
        
        var pathsInfoCut = creationOfPathsInfoCut(
            intersectedPoints: intersectedPoints,
            segments: segments,
            pathsInfo: pathsInfo)
        
        //---------------------
        
        
        var previousProbabilityOfGrowth: Double = 0.0
        var probabilityOfGrowth = 0.0
        
        for pathIndex in 0..<pathsInfoCut.count {
            
            let pathInfoCut = pathsInfoCut[pathIndex]
            previousProbabilityOfGrowth = probabilityOfGrowth
            
            if pathInfoCut.isSampled { //Is sampled
                probabilityOfGrowth = 1.1
                ///print("\(pathIndex) Sampled")
            } else { // Is not sampled
                if pathInfoCut.isFlamed { //Is flamed
                    if !(pathInfoCut.pathCutIndex > 0) { // If its the first one path
                        probabilityOfGrowth = 0.0
                        ///print("\(pathIndex) Flamed, first one")
                        
                    } else { // if its not the first one
                        if let nextTouchedStrokeIndex = pathsInfoCut[pathIndex - 1].nextTouchedStrokeIndex { // if are real tocuches
                            let touchedProbability = pathsInfoCut.last { $0.strokeIndex == nextTouchedStrokeIndex}?.probabilityOfGrowth
                            probabilityOfGrowth = {
                                if previousProbabilityOfGrowth < (touchedProbability ?? 0.0) {
                                    ///print("taked touched")
                                    return getProbabiltyLog(current: (touchedProbability ?? 0.0))
                                } else {
                                    return previousProbabilityOfGrowth * 0.9
                                }
                            }()
                            //probabilityOfGrowth = max(previousProbabilityOfGrowth,touchedProbability ?? 0.0)
                            //print("\(pathIndex) Flamed, Not first one, real touches")
                            
                        } else { // if there is no real touches
                            probabilityOfGrowth = previousProbabilityOfGrowth
                            //print("\(pathIndex) Flamed, Not first one, no real touches")
                            
                        }
                    }
                } else { //Is not Flamed
                    if !(pathInfoCut.pathCutIndex > 0) { // If its the first one path
                        probabilityOfGrowth = previousProbabilityOfGrowth
                        //print("\(pathIndex) no flamed, first one")
                        
                    } else { // IF its not the first one path
                        if let nextTouchedStrokeIndex = pathsInfoCut[pathIndex - 1].nextTouchedStrokeIndex { // if are real tocuches
                            let touchedProbability = pathsInfoCut.last { $0.strokeIndex == nextTouchedStrokeIndex}?.probabilityOfGrowth
                            probabilityOfGrowth = {
                                if previousProbabilityOfGrowth < (touchedProbability ?? 0.0) {
                                    ///print("taked touched")
                                    return getProbabiltyLog(current: (touchedProbability ?? 0.0))
                                } else {
                                    return previousProbabilityOfGrowth * 0.9
                                }
                            }()
                            //probabilityOfGrowth = max(previousProbabilityOfGrowth,touchedProbability ?? 0.0)
                            //print("\(pathIndex) no flamed, Not first one, real touches")
                            
                        } else { // if there is no real touches
                            probabilityOfGrowth = previousProbabilityOfGrowth
                            //print("\(pathIndex) no flamed, Not first one, no real touches")
                            
                        }
                    }
                }
            }
            pathsInfoCut[pathIndex].probabilityOfGrowth = probabilityOfGrowth
            pathsInfoCut[pathIndex].nextTouchedStrokeIndex = {
                pathsInfoCut[pathIndex].touchedStrokeIndex.filter {
                    $0 < pathsInfoCut[pathIndex].strokeIndex
                }.last
            }()
            //print (pathsInfoCut[pathIndex].nextTouchedStrokeIndex ?? "NONE")
            let dotStrokes = addDots(from: pathInfoCut.path, interval: 10, probabilityOfGrowth: probabilityOfGrowth, color: microorganism.color)
            withAnimation {
                drawing.strokes.append(contentsOf: dotStrokes)
            }
            
            
        }
        
        func getProbabiltyLog(current: Double, k: Double = 0.5) -> Double {
            return max(0, current - k * log(1 + current))
        }
        print("Incubation finished")
        
        path.append(.resultView(microorganism: microorganism, cultureMedia: cultureMedia))
    }
}

#Preview {
    LabView(path: .constant([]),
            microorganism: Microorganism(name: """
Saccharomyces 
cerevisiae
""", type: "", color: .red, textColor: .yeastText, image: "yeast"),
            cultureMedia: CultureMedia(name: "", type: "", color: .cyan, textColor: .cultureBloodAgar, image: ""), drawing: .constant(PKDrawing()))
}
