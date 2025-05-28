//
//  ARSceneView.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 27/05/25.
//


import SwiftUI
import RealityKit
import PencilKit

struct ARSceneView : View {
    var microorganism: Microorganism
    var cultureMedia: CultureMedia
    @Binding var dotStrokes: [PKStroke]
    var body: some View {
        RealityView { content in

            // Create a cube model
            let model = Entity()
            let mesh = MeshResource.generateCylinder(height: 0.02, radius: 0.055)
            let material = SimpleMaterial(color: cultureMedia.color.withAlphaComponent(0.98), roughness: 0.15, isMetallic: false)
            model.components.set(ModelComponent(mesh: mesh, materials: [material]))
            model.position = [0, 0, 0]
            
            // Create horizontal plane anchor for the content
            let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.1, 0.1)))
            anchor.addChild(model)

            
            // Generate spheres for dotStrokes (UFCs)
            let radiusMeters: Float = 0.003  // Radius of the small spheres
            let canvasSize = canvasWidth     // canvasWidth and canvasHeight are equal
            let arDishRadius: Float = 0.05   // In meters, for a 10cm dish
            let center = CGPoint(x: canvasSize / 2, y: canvasSize / 2)

            for stroke in dotStrokes {
                guard let point = stroke.path.first?.location else { continue }

                // Get offset from center
                let offsetX = point.x - center.x
                let offsetY = point.y - center.y

                // Convert to relative radius
                let distanceFromCenter = sqrt(offsetX * offsetX + offsetY * offsetY)

                // Skip if outside circular dish
                if distanceFromCenter > canvasSize / 2 { continue }

                // Normalize to [-1...1] range, then scale to dish radius in meters
                let normalizedX = Float(offsetX / (canvasSize / 2)) * arDishRadius
                let normalizedZ = Float(offsetY / (canvasSize / 2)) * arDishRadius * -1  // Flip vertically if needed

                // Create the sphere entity
                let colony = Entity()
                let colonyMesh = MeshResource.generateSphere(radius: radiusMeters)
                let colonyMaterial = SimpleMaterial(color: microorganism.color, roughness: 0.12, isMetallic: false)
                colony.components.set(ModelComponent(mesh: colonyMesh, materials: [colonyMaterial]))
                colony.position = SIMD3<Float>(normalizedX, 0.008, normalizedZ)
                anchor.addChild(colony)
            }            

            // Add the horizontal plane anchor to the scene
            content.add(anchor)
            content.camera = .spatialTracking

        }
        .edgesIgnoringSafeArea(.all)
    }

}

#Preview {
    ARSceneView(microorganism: Microorganism(name: """
Saccharomyces 
cerevisiae
""", type: "", color: .red, textColor: .yeastText, image: "yeast"), cultureMedia: CultureMedia(name: "", type: "", color: .cyan, textColor: .textNutrient, image: ""), dotStrokes: .constant([]))
}
