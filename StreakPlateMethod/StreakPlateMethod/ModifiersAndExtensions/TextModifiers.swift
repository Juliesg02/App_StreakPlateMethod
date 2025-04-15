//
//  ViewModifiers.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 12/04/25.
//

import SwiftUI

struct StyledTextButton: ViewModifier {
    var textColor: Color = Color.white
    var backgroundColor: Color = Color.accentColor
    
    func body (content: Content) -> some View {
        content
            .font(.title)
            .padding()
            .padding(.horizontal, 30)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(12)
    }
}

extension View {
    func styledTextButton(textColor: Color = .white, backgroundColor: Color = .accentColor) -> some View {
        self.modifier(StyledTextButton(textColor: textColor, backgroundColor: backgroundColor))
    }
}

