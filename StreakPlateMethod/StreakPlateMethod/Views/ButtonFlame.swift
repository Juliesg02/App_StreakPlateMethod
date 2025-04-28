//
//  ButtonFlame.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 18/04/25.
//

import SwiftUI

struct ButtonFlame: View {
    @Binding var isFlamed: Bool //= false
    @Binding var isSample: Bool //= true
    var width: CGFloat
    
    @State var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var isPressing: Bool = false
    @State var countingTime: Int = 0
    @State var animationIndex: Int = 0
    let flameFrames: [String] = ["Frame1", "Frame2", "Frame3", "Frame4", "Frame5", "Frame6", "Frame7",]
    
    
    var body: some View {
        VStack {
            VStack {
                Text(isFlamed ? "Flamed" : isPressing ? "Hold": " ")
                    .font(.title)
                    .bold()
                    .foregroundStyle(isFlamed ? .orange : isPressing ? Color.secondary: Color.secondary)
                
                Image(flameFrames[animationIndex])
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: width)
                
                Text("Hold to flame the loop")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .frame(width: width)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .onLongPressGesture(minimumDuration: 3.0) {
                isFlamed = true
                isSample = false
            } onPressingChanged: { isPressing in
                print("Started pressing")
                self.isPressing = isPressing
                //start holding
                if isPressing{
                    countingTime = 0
                    animationIndex = 0
                } else {
                    print("Stopped pressing")
                    //if user stop holding before flame
                    if countingTime < 6 {
                    }
                    resetFlameTimer()
                }
            }
            .onReceive(timer) { timer in
                if isPressing {
                    countingTime += 1
                    if countingTime >= 6 {
                        animationIndex = 6
                        if !isFlamed {
                            isFlamed = true
                            isSample = false
                        }
                    } else {
                        withAnimation {
                            animationIndex += 1
                        }
                    }
                }
            }
            
            Text("isFlamed:\(isFlamed)")
            Text("isSample:\(isSample)")
            Text("isPressing:\(isPressing)")
            Text("countingTime:\(countingTime)")
            Text("animationIndex:\(animationIndex)")
            Button("reset", action: { isSample = true; isFlamed = false})
        }
    }
    
    func resetFlameTimer() {
        timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
        countingTime = 0
        withAnimation(.easeInOut(duration: 2)) {
            animationIndex = 0
        }
    }
}

#Preview {
        ButtonFlame(
            isFlamed: .constant(false),
            isSample: .constant(true),
            width: 150
        )
}
