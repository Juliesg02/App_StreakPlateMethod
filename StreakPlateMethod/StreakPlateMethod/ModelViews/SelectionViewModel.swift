//
//  SelectionViewModel.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 15/04/25.
//

import SwiftUI

let microorganisms: [Microorganism] = [
    Microorganism(name: """
                  Salmonella 
                  enterica
                  """,
                  type: "Bacteria", color: .salmonellaColor, image: "salmonella"),
    Microorganism(name: """
                    Saccharomyces
                    cerevisiae
                    """,
                  type: "Yeast", color: .yeastColor, image: "yeast"),
    Microorganism(name: """
                  Pseudomonas 
                  fluorescens
                  """,
                  type: "Bacteria", color: .pseudomonasFluoColor, image: "pseudomonas"),
    Microorganism(name: """
                    Klebsiella
                    pneumoniae
                    """,
                  type: "Bacteria", color: .klebsiellaColor, image: "klebsiella")
    
]

let cultureMedias: [CultureMedia] = [
    CultureMedia(name: "Nutrient Agar",
                 type: "General", color: .cultureNutrient, image: "nutrientAgar"),
    CultureMedia(name: "MacConkey Agar",
                 type: "Selective", color: .cultureMacConkey, image: "macconkey"),
    CultureMedia(name: "Blood Agar",
                 type: "Enriched", color: .cultureBloodAgar, image: "bloodAgar"),
    CultureMedia(name: "Cetrimide Agar",
                 type: "Selective", color: .cultureCetrimide, image: "cetrimideAgar")
    
]
