//
//  BallModel.swift
//  StreakPlateMethod
//
//  Created by Julio Enrique Sanchez Guajardo on 15/06/25.
//
import SwiftUI


//For the color of the ball
enum CultureMediumType: String, Codable {
    case nutrient
    case macConkey
    case bloodAgar
    case cetrimide
}


extension CultureMediumType {
    var backgroundColor: UIColor {
        switch self {
        case .nutrient:
            return .cultureNutrient
        case .macConkey:
            return .cultureMacConkey
        case .bloodAgar:
            return .cultureBloodAgar
        case .cetrimide:
            return .cultureCetrimide
        }
    }
    
    var swiftUIColor: Color {
        Color(self.backgroundColor)
    }
}

func mapCultureMediaToType(_ media: CultureMedia) -> CultureMediumType {
    switch media.name {
    case "Nutrient Agar":
        return .nutrient
    case "MacConkey Agar":
        return .macConkey
    case "Blood Agar":
        return .bloodAgar
    case "Cetrimide Agar":
        return .cetrimide
    default:
        return .nutrient // fallback
    }
}


// for the image that is gonna have the ball
func imageName(for microorganism: String) -> String {
    let cleanName = microorganism.lowercased()
    
    if cleanName.contains("klebsiella") {
        return "StreakLab-Klebsiella"
    } else if cleanName.contains("pseudomonas") {
        return "StreakLab-Pseudomonas"
    } else if cleanName.contains("saccharomyces") {
        return "StreakLab-Saccharomyces"
    } else if cleanName.contains("salmonella") {
        return "StreakLab-Salmonella"
    } else {
        return "StreakLab-Pseudomonas" // fallback image
    }
}

// record of the data of the ball
struct PetriRecord: Identifiable, Codable, Equatable {
    var id = UUID()
    let microorganismImage: String
    let medium: CultureMediumType
}


class PetriStorage: ObservableObject {
    @Published var records: [PetriRecord] = [] {
        didSet {
            saveRecords()
        }
    }
    let maxCount = 10

    init() {
        loadRecords()
    }

    func addRecord(microorganism: Microorganism, cultureMedia: CultureMedia) {
            let image = imageName(for: microorganism.name)
            let mediumType = mapCultureMediaToType(cultureMedia)
            
            let newRecord = PetriRecord(microorganismImage: image, medium: mediumType)
            records.insert(newRecord, at: 0)
            if records.count > maxCount {
                records.removeLast()
            }
        }

    private func saveRecords() {
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: "PetriRecords")
            print(records)
        }
    }

    private func loadRecords() {
        if let data = UserDefaults.standard.data(forKey: "PetriRecords"),
           let decoded = try? JSONDecoder().decode([PetriRecord].self, from: data) {
            records = decoded
        }
    }
}
