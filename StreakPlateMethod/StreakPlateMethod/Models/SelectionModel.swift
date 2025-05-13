//
//  SelectionModel.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 15/04/25.
//

import SwiftUI

struct Microorganism: Equatable, Hashable {
    let name: String
    let type: String
    let color : UIColor
    let textColor : UIColor
    let image : String
}

struct CultureMedia: Equatable, Hashable {
    let name: String
    let type: String
    let color : UIColor
    let textColor : UIColor
    let image : String
}
