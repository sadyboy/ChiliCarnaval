import Foundation
import SwiftUI

struct Pepper: Identifiable {
    let id: String
    let name: String
    let scientificName: String
    let type: PepperType
    let scovilleRating: Int
    let origin: String
    let description: String
    let unlockCost: Int
    let family: String
    let region: String
    let size: String
    let growthTime: String
    let commonUses: [String]
    let funFact: String
    
    init(id: String = UUID().uuidString,
         name: String,
         scientificName: String,
         scovilleRating: Int,
         origin: String,
         description: String,
         type: PepperType,
         unlockCost: Int = 0,
         family: String = "",
         region: String = "",
         size: String = "",
         growthTime: String = "",
         commonUses: [String] = [],
         funFact: String = "") {
        self.id = id
        self.name = name
        self.scientificName = scientificName
        self.scovilleRating = scovilleRating
        self.origin = origin
        self.description = description
        self.type = type
        self.unlockCost = unlockCost
        self.family = family
        self.region = region
        self.size = size
        self.growthTime = growthTime
        self.commonUses = commonUses
        self.funFact = funFact
    }
}

enum PepperType: String, Codable, CaseIterable {
    case mild = "Mild"
    case medium = "Medium"
    case hot = "Hot"
    case extraHot = "Very Hot"
    case extreme = "Extreme"
    
    var color: Color {
        switch self {
            case .mild: return .green
            case .medium: return .yellow
            case .hot: return .orange
            case .extraHot: return .red
            case .extreme: return .purple
        }
    }
    
    var points: Int {
        switch self {
            case .mild: return 10
            case .medium: return 25
            case .hot: return 50
            case .extraHot: return 100
            case .extreme: return 200
        }
    }
}

extension Pepper {
    static let samplePeppers: [Pepper] = [
        Pepper(
            name: "Bell Pepper",
            scientificName: "Capsicum annuum",
            scovilleRating: 0,
            origin: "South America",
            description: "Bell peppers are the only pepper that doesn't produce capsaicin, the compound that makes peppers hot. They come in various colors including green, red, yellow, and orange, each with slightly different nutritional profiles.",
            type: .mild,
            unlockCost: 0,
            family: "C. annuum",
            region: "Global",
            size: "10-15 cm",
            growthTime: "60-90 days",
            commonUses: ["Salads", "Stir-fry", "Stuffed peppers", "Roasting"],
            funFact: "Green bell peppers are just unripe red peppers!"
        ),
        
        Pepper(
            name: "Poblano",
            scientificName: "Capsicum annuum",
            scovilleRating: 2000,
            origin: "Mexico",
            description: "A mild pepper with rich flavor, often used in traditional Mexican dishes. When dried, it's called an 'ancho' chili and develops a sweeter, raisin-like flavor.",
            type: .mild,
            unlockCost: 50,
            family: "C. annuum",
            region: "Mesoamerica",
            size: "10-15 cm",
            growthTime: "65-80 days",
            commonUses: ["Chiles rellenos", "Mole", "Sauces"],
            funFact: "Poblanos are the pepper used to make authentic chiles rellenos"
        ),
        
        Pepper(
            name: "Jalapeño",
            scientificName: "Capsicum annuum",
            scovilleRating: 5000,
            origin: "Mexico",
            description: "One of the most popular peppers worldwide, named after the Mexican city of Xalapa. The heat level can vary significantly between individual peppers.",
            type: .medium,
            unlockCost: 100,
            family: "C. annuum",
            region: "Mexico",
            size: "5-9 cm",
            growthTime: "70-80 days",
            commonUses: ["Salsa", "Nachos", "Pickling", "Spicy dishes"],
            funFact: "Chipotle peppers are smoked, dried jalapeños"
        ),
        
        Pepper(
            name: "Serrano",
            scientificName: "Capsicum annuum",
            scovilleRating: 23000,
            origin: "Mexico",
            description: "Small but potent, Serrano peppers are significantly hotter than jalapeños. They have a bright, crisp flavor and are often used fresh in salsas and sauces.",
            type: .hot,
            unlockCost: 200,
            family: "C. annuum",
            region: "Mexico",
            size: "3-6 cm",
            growthTime: "75-85 days",
            commonUses: ["Pico de gallo", "Hot sauces", "Marinades"],
            funFact: "Serrano means 'from the mountains' in Spanish"
        ),
        
        Pepper(
            name: "Cayenne pepper",
            scientificName: "Capsicum annuum",
            scovilleRating: 50000,
            origin: "French Guiana",
            description: "A popular spice, often sold ground. The thin, curved peppers dry easily and are commonly used in powder form to add heat to dishes worldwide.",
            type: .hot,
            unlockCost: 300,
            family: "C. annuum",
            region: "South America",
            size: "10-15 cm",
            growthTime: "70-80 days",
            commonUses: ["Spice rubs", "Hot sauces", "Cajun cuisine"],
            funFact: "Named after the city of Cayenne in French Guiana"
        ),
        
        Pepper(
            name: "Habanero",
            scientificName: "Capsicum chinense",
            scovilleRating: 350000,
            origin: "Amazonia",
            description: "A very hot pepper with a distinctive fruity aroma. Despite its intense heat, it has complex flavor notes that make it popular in gourmet hot sauces.",
            type: .extraHot,
            unlockCost: 500,
            family: "C. chinense",
            region: "Caribbean",
            size: "3-6 cm",
            growthTime: "90-100 days",
            commonUses: ["Hot sauces", "Salsas", "Marinades"],
            funFact: "Habanero means 'from Havana' in Spanish"
        ),
        
        Pepper(
            name: "Ghost Pepper",
            scientificName: "Capsicum chinense",
            scovilleRating: 1041427,
            origin: "India",
            description: "One of the hottest peppers, known as Bhut Jolokia. It held the Guinness World Record for hottest pepper from 2007 to 2010.",
            type: .extreme,
            unlockCost: 1000,
            family: "C. chinense",
            region: "Northeast India",
            size: "5-8 cm",
            growthTime: "120-150 days",
            commonUses: ["Extreme hot sauces", "Powders", "Challenge foods"],
            funFact: "Bhut Jolokia translates to 'Bhutanese pepper' in Assamese"
        ),
        
        Pepper(
            name: "Carolina Reaper",
            scientificName: "Capsicum chinense",
            scovilleRating: 2200000,
            origin: "USA",
            description: "The hottest pepper in the world according to the Guinness Book of World Records. It has a sweet, fruity flavor followed by intense, lingering heat.",
            type: .extreme,
            unlockCost: 2000,
            family: "C. chinense",
            region: "South Carolina, USA",
            size: "5-8 cm",
            growthTime: "90-110 days",
            commonUses: ["Competitions", "Extract production", "Challenge foods"],
            funFact: "Bred by Ed Currie in South Carolina, it has a distinctive stinger tail"
        )
    ]
}
extension EncyclopediaViewModel {
    var hasUnlockedEntries: Bool {
        !unlockedEntries.isEmpty
    }
    
    var completionPercentage: Int {
        guard !peppers.isEmpty else { return 0 }
        return Int(Double(unlockedEntries.count) / Double(peppers.count) * 100)
    }
    
    func hasUnlockedType(_ type: PepperType) -> Bool {
        peppers.contains { $0.type == type && unlockedEntries.contains($0.id) }
    }
}

