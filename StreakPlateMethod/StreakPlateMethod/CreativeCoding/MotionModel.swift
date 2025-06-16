//
//  MotionModel.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 15/06/25.
//

import SwiftUI
import CoreMotion


//Ball struct
struct BallState {
    var position: CGPoint = .zero
    var velocity: CGPoint = .zero
    var rotationAngle: Angle = .zero
    
    var color: Color
    var imageName: String
    
    // Add initializer from PetriRecord
    init(from record: PetriRecord, position: CGPoint = .zero) {
        self.position = position
        self.velocity = .zero
        self.rotationAngle = .zero
        self.color = record.medium.swiftUIColor
        self.imageName = record.microorganismImage
    }
}

class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    private var timer: Timer?

    @Published var balls: [BallState] = []  // Initially

    private var screenSize: CGSize = .zero
    private var objectSize: CGSize = .zero

    func configure(screenSize: CGSize, objectSize: CGSize) {
        self.screenSize = screenSize
        self.objectSize = objectSize
    }
    
    func loadBalls(from records: [PetriRecord]) {
        balls = records.map { record in
            // You can randomize positions if you want
            let randomX = CGFloat.random(in: -screenSize.width / 2 ... screenSize.width / 2)
            let randomY = CGFloat.random(in: -screenSize.height / 2 ... screenSize.height / 2)
            return BallState(from: record, position: CGPoint(x: randomX, y: randomY))
        }
    }
    
    init() {
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        motionManager.startDeviceMotionUpdates()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { _ in
            guard let motion = self.motionManager.deviceMotion else { return }

            let ax = CGFloat(motion.gravity.x) * 80
            let ay = CGFloat(-motion.gravity.y) * 80

            for i in self.balls.indices {
                self.balls[i].velocity.x += ax * 0.1
                self.balls[i].velocity.y += ay * 0.1

                self.balls[i].velocity.x *= 0.98
                self.balls[i].velocity.y *= 0.98

                self.balls[i].position.x += self.balls[i].velocity.x * 0.1
                self.balls[i].position.y += self.balls[i].velocity.y * 0.1

                let halfW = self.objectSize.width / 2
                let halfH = self.objectSize.height / 2
                let minX = -self.screenSize.width / 2 + halfW
                let maxX = self.screenSize.width / 2 - halfW
                let minY = -self.screenSize.height / 2 + halfH
                let maxY = self.screenSize.height / 2 - halfH

                // Rotation amount based on speed
                let speed = min(sqrt(self.balls[i].velocity.x * self.balls[i].velocity.x +
                                     self.balls[i].velocity.y * self.balls[i].velocity.y), 300)
                let rotationAmount = speed * 0.05

                // Vertical walls
                if self.balls[i].position.x < minX {
                    self.balls[i].position.x = minX
                    self.balls[i].velocity.x *= -0.3
                    let rotation = self.balls[i].velocity.y > 0 ? rotationAmount : -rotationAmount
                    self.balls[i].rotationAngle += .degrees(rotation)
                } else if self.balls[i].position.x > maxX {
                    self.balls[i].position.x = maxX
                    self.balls[i].velocity.x *= -0.3
                    let rotation = self.balls[i].velocity.y > 0 ? -rotationAmount : rotationAmount
                    self.balls[i].rotationAngle += .degrees(rotation)
                }

                // Horizontal walls
                if self.balls[i].position.y < minY {
                    self.balls[i].position.y = minY
                    self.balls[i].velocity.y *= -0.3
                    let rotation = self.balls[i].velocity.x > 0 ? -rotationAmount : rotationAmount
                    self.balls[i].rotationAngle += .degrees(rotation)
                } else if self.balls[i].position.y > maxY {
                    self.balls[i].position.y = maxY
                    self.balls[i].velocity.y *= -0.3
                    let rotation = self.balls[i].velocity.x > 0 ? rotationAmount : -rotationAmount
                    self.balls[i].rotationAngle += .degrees(rotation)
                }
                
                // Apply extra friction if touching any wall
                let touchingLeftOrRightWall = self.balls[i].position.x <= minX || self.balls[i].position.x >= maxX
                let touchingTopOrBottomWall = self.balls[i].position.y <= minY || self.balls[i].position.y >= maxY

                if touchingLeftOrRightWall || touchingTopOrBottomWall {
                    self.balls[i].velocity.x *= 0.98 // Apply extra friction
                    self.balls[i].velocity.y *= 0.98
                }
                
                let velocityThreshold: CGFloat = 0.05
                if abs(self.balls[i].velocity.x) < velocityThreshold {
                    self.balls[i].velocity.x = 0
                }
                if abs(self.balls[i].velocity.y) < velocityThreshold {
                    self.balls[i].velocity.y = 0
                }
            }
            
            // Check for collision between balls
            for i in 0..<self.balls.count {
                for j in i+1..<self.balls.count {
                    let ballA = self.balls[i]
                    let ballB = self.balls[j]

                    let dx = ballB.position.x - ballA.position.x
                    let dy = ballB.position.y - ballA.position.y
                    let distance = sqrt(dx * dx + dy * dy)
                    let minDistance: CGFloat = 80 // Ball diameter

                    if distance < minDistance && distance > 0 {
                        let overlap = minDistance - distance
                        let nx = dx / distance
                        let ny = dy / distance

                        // Separate the balls
                        self.balls[i].position.x -= nx * overlap / 2
                        self.balls[i].position.y -= ny * overlap / 2
                        self.balls[j].position.x += nx * overlap / 2
                        self.balls[j].position.y += ny * overlap / 2

                        // Swap their velocity components along the normal
                        let vA = self.balls[i].velocity
                        let vB = self.balls[j].velocity
                        let dotA = vA.x * nx + vA.y * ny
                        let dotB = vB.x * nx + vB.y * ny
                        let impulse = (dotA - dotB)

                        self.balls[i].velocity.x -= impulse * nx * 0.5
                        self.balls[i].velocity.y -= impulse * ny * 0.5
                        self.balls[j].velocity.x += impulse * nx * 0.5
                        self.balls[j].velocity.y += impulse * ny * 0.5
                    }
                }
            }

        }
    }

    deinit {
        motionManager.stopDeviceMotionUpdates()
        timer?.invalidate()
    }
}




