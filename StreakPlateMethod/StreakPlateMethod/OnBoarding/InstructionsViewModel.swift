//
//  InstructionsViewModel.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 12/04/25.
//
import Foundation


struct Instruction {
    let image: String
    let description: String
    let title: String
    let explication : String
    let secondImage: String?
    let secondExplication: String?
}

let Instructions: [Instruction] = [
    Instruction(
        image: "Loop",
        description: "A loop used to transfer bacteria",
        title: "Step 1: Grab Your Loop",
        explication: "Your loop is your key tool for streaking bacteria. In this simulation, your Apple Pencil acts as a sterilized inoculating loop. Get ready to work with precision!",
        secondImage: nil,
        secondExplication: nil
    ),
    
    Instruction(
        image: "TakeSample",
        description: "A bacterial colony being picked up",
        title: "Step 2: Collect Your Sample",
        explication: "Gently touch a bacterial colony with your loop. A proper technique ensures an effective transfer to the agar plate.",
        secondImage: nil,
        secondExplication: nil
    ),
    
    Instruction(
        image: "Inoculate",
        description: "Petri Dish with Nutrient Agar and Loop",
        title: "Step 3: Prepare the Plate",
        explication: "You’ll be streaking bacteria across a Petri dish filled with nutrient-rich agar. The goal? To dilute the bacteria step by step until individual colonies form.",
        secondImage: nil,
        secondExplication: nil
    ),
    
    Instruction(
        image: "FirstStreak",
        description: "The first quadrant streak",
        title: "Step 4: The First Streak",
        explication: "Using your sampled loop, gently streak in one section of the plate. Keep the strokes controlled and close together.",
        secondImage: "noventa",
        secondExplication: "Pro Tip: Rotate the plate 90° after each streak 🤫."
    ),
    
    Instruction(
        image: "Flame",
        description: "A loop being sterilized in a flame",
        title: "Step 5: Sterilize the Loop",
        explication: "Before moving on, flame your loop to eliminate any remaining bacteria. Wait until it glows red-hot, this ensures it's fully sterilized. A clean loop means each new streak will have fewer bacteria, helping you achieve proper isolation.",
        secondImage: nil,
        secondExplication: nil
    ),
    
    Instruction(
        image: "SecondStreak",
        description: "The second quadrant streak",
        title: "Step 6: The Second Streak",
        explication: "Drag the sterilized loop from the first streak into the next quadrant. This spreads the bacteria further, decreasing their density.",
        secondImage: "Fire",
        secondExplication: "Don't forget to flame after each streak."
    ),
    
    
    Instruction(
        image: "ThirdStreak",
        description: "The third quadrant streak",
        title: "Step 7: The Third Streak",
        explication: "Following the same technique, drag a few bacteria from the second streak into the third quadrant.",
        secondImage: "Fire",
        secondExplication: "Don't forget to flame after each streak."
    ),
    
    Instruction(
        image: "ForthStreak",
        description: "The fourth and final streak",
        title: "Step 8: The Final Streak",
        explication: "For the last section, streak once again from the third quadrant into the fourth. This final streak should have the lowest bacterial concentration.",
        secondImage: "Fire",
        secondExplication: "Don't forget to flame after each streak."
    ),
    
    Instruction(
        image: "Petri",
        description: "A Petri dish before incubation",
        title: "Step 9: Incubation Time!",
        explication: "Now, we wait! Place your plate in the incubator and let the bacteria grow. Soon, you’ll see individual colonies forming!",
        secondImage: nil,
        secondExplication: nil
    )
]
