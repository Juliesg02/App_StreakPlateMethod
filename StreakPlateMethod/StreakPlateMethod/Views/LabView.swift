//
//  LabView.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 17/04/25.
//

import SwiftUI

struct LabView: View {
    @Binding var path: [Screen]
    var body: some View {
        Text("This is the lab")
    }
}

#Preview {
    LabView(path: .constant([]))
}
