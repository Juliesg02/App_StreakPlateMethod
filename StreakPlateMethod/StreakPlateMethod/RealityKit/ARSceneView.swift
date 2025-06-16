//
//  ARSceneView.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 27/05/25.
//
import SwiftUI
import RealityKit
import ARKit
import PencilKit

struct ARSceneView: View {
    var microorganism: Microorganism
    var cultureMedia: CultureMedia
    @Binding var dotStrokes: [PKStroke]

    @State private var planeDetected = false

    var body: some View {
        ZStack {
            ARViewContainer(
                microorganism: microorganism,
                cultureMedia: cultureMedia,
                dotStrokes: dotStrokes,
                planeDetected: $planeDetected
            )
            .edgesIgnoringSafeArea(.all)

            if !planeDetected {
                VStack {
                    Text("Move your device until a flat surface is detected")
                        .font(.headline)
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                .transition(.opacity)
                .animation(.easeInOut, value: planeDetected)
            }
        }
    }
}

// UIViewRepresentable wrapper for ARView (RealityKit 2)
struct ARViewContainer: UIViewRepresentable {
    var microorganism: Microorganism
    var cultureMedia: CultureMedia
    var dotStrokes: [PKStroke]
    @Binding var planeDetected: Bool

    func makeCoordinator() -> ARDelegate {
        ARDelegate(planeDetected: $planeDetected)
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.session.delegate = context.coordinator

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic
        arView.session.run(config)

        // Add Petri Dish anchor
        addPetriDish(to: arView)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    private func addPetriDish(to arView: ARView) {
        let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.1, 0.1])
        
        let model = Entity()
        let mesh = MeshResource.generateCylinder(height: 0.02, radius: 0.055)
        let material = SimpleMaterial(color: cultureMedia.color.withAlphaComponent(0.98), roughness: 0.15, isMetallic: false)
        model.components.set(ModelComponent(mesh: mesh, materials: [material]))
        model.position = [0, 0, 0]
        anchor.addChild(model)

        // Place colonies (UFCs)
        let radiusMeters: Float = 0.003
        let canvasSize = canvasWidth
        let arDishRadius: Float = 0.05
        let center = CGPoint(x: canvasSize / 2, y: canvasSize / 2)

        for stroke in dotStrokes {
            guard let point = stroke.path.first?.location else { continue }
            let offsetX = point.x - center.x
            let offsetY = point.y - center.y
            let distanceFromCenter = sqrt(offsetX * offsetX + offsetY * offsetY)
            if distanceFromCenter > canvasSize / 2 { continue }

            let normalizedX = Float(offsetX / (canvasSize / 2)) * arDishRadius
            let normalizedZ = Float(offsetY / (canvasSize / 2)) * arDishRadius * -1

            let colony = Entity()
            let colonyMesh = MeshResource.generateSphere(radius: radiusMeters)
            let colonyMaterial = SimpleMaterial(color: microorganism.color, roughness: 0.12, isMetallic: false)
            colony.components.set(ModelComponent(mesh: colonyMesh, materials: [colonyMaterial]))
            colony.position = SIMD3<Float>(normalizedX, 0.008, normalizedZ)
            anchor.addChild(colony)
        }

        arView.scene.addAnchor(anchor)
    }
}

class ARDelegate: NSObject, ARSessionDelegate {
    @Binding var planeDetected: Bool

    init(planeDetected: Binding<Bool>) {
        _planeDetected = planeDetected
    }

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if anchor is ARPlaneAnchor {
                DispatchQueue.main.async {
                    self.planeDetected = true
                }
            }
        }
    }
}

#Preview {
    ARSceneView(microorganism: Microorganism(name: """
Saccharomyces 
cerevisiae
""", type: "", color: .red, textColor: .yeastText, image: "yeast"), cultureMedia: CultureMedia(name: "", type: "", color: .cyan, textColor: .textNutrient, image: ""), dotStrokes: .constant([]))
}
