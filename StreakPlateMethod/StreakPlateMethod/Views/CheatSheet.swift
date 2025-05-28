//
//  SwiftUIView.swift
//
//

import SwiftUI

struct CheatSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                Text("4 Quadrant Streak Method")
                    .font(.title)
                    .bold()
                Text("Cheat Sheet")
                    .font(.headline)
                    .bold()
                    .padding(.bottom)
                Text("""
            1. Take a sample by touching the microorganism colony with your loop.
            2. Streak in section 1 as shown in the image, keeping strokes controlled and close.
            3. Rotate the plate 90°.
            4. Flame the loop until red-hot and let it cool.
            5. Streak in section 2, dragging from the previous streak.
            6. Repeat steps 3, 4, and 5 for sections 3 and 4 of the petri dish.
            7. Incubate.
            """)
                .font(.body)
                
                Image("HelpingStreaks")
                    .resizable()
                    .scaledToFit()
                
                Button {
                    dismiss()
                } label: {
                    Text("Close")
                        .font(.callout)
                        .foregroundStyle(.red)
                }
                .padding()
                
            }
            .padding()
        }
    }
    
}

#Preview {
    //   CheatSheetView(dismiss: DismissAction())
}
