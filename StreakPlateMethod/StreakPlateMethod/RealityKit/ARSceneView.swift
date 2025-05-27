//
//  ARSceneView.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 27/05/25.
//


import SwiftUI
import RealityKit

struct ARSceneView : View {
    var body: some View {
        RealityView { content in

            // Create a cube model
            let model = Entity()
            let mesh = MeshResource.generateCylinder(height: 0.02, radius: 0.05)
            let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: false)
            model.components.set(ModelComponent(mesh: mesh, materials: [material]))
            model.position = [0, 0, 0]
            
            // Create horizontal plane anchor for the content
            let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.1, 0.1)))
            anchor.addChild(model)

            
            // Generate multiple spheres (UFCs)
            let ufcPositions: [SIMD3<Float>] = (0..<20).map { _ in
                let x = Float.random(in: -0.04...0.04)
                let z = Float.random(in: -0.04...0.04)
                return SIMD3<Float>(x, 0.007, z) // y is fixed above the dish
            }
            
            
            for position in ufcPositions {
                  let colony = Entity()
                  let colonyMesh = MeshResource.generateSphere(radius: 0.005)
                  let colonyMaterial = SimpleMaterial(color: .red, roughness: 0.12, isMetallic: false)
                  colony.components.set(ModelComponent(mesh: colonyMesh, materials: [colonyMaterial]))
                  colony.position = position
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
    ARSceneView()
}
