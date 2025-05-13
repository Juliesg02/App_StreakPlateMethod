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
                  type: "Bacteria", color: .salmonellaColor, textColor: .salmonellaText, image: "salmonella"),
    Microorganism(name: """
                    Saccharomyces
                    cerevisiae
                    """,
                  type: "Yeast", color: .yeastColor, textColor: .yeastText, image: "yeast"),
    Microorganism(name: """
                  Pseudomonas 
                  fluorescens
                  """,
                  type: "Bacteria", color: .pseudomonasFluoColor, textColor: .pseudomonasFluoText, image: "pseudomonas"),
    Microorganism(name: """
                    Klebsiella
                    pneumoniae
                    """,
                  type: "Bacteria", color: .klebsiellaColor, textColor: .klebsiellaText, image: "klebsiella")
    
]

let cultureMedias: [CultureMedia] = [
    CultureMedia(name: "Nutrient Agar",
                 type: "General", color: .cultureNutrient, textColor: .textNutrient, image: "nutrientAgar"),
    CultureMedia(name: "MacConkey Agar",
                 type: "Selective", color: .cultureMacConkey, textColor: .textMacConkey, image: "macconkey"),
    CultureMedia(name: "Blood Agar",
                 type: "Enriched", color: .cultureBloodAgar, textColor: .textBloodAgar, image: "bloodAgar"),
    CultureMedia(name: "Cetrimide Agar",
                 type: "Selective", color: .cultureCetrimide, textColor: .textCetrimide, image: "cetrimideAgar")
    
]
