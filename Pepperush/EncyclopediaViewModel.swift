import Foundation
import Combine

class EncyclopediaViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedFilter: PepperType? = nil
    @Published var peppers: [Pepper] = []
    @Published var unlockedEntries: Set<String> = []
    
    private let dataManager = DataManager.shared
    
    init() {
        loadPeppers()
        loadUnlockedEntries()
        
        // First pepper is always unlocked
        if !peppers.isEmpty && !unlockedEntries.contains(peppers[0].id) {
            unlockEntry(pepperId: peppers[0].id)
        }
    }
    
    var filteredPeppers: [Pepper] {
        var filtered = peppers
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.scientificName.localizedCaseInsensitiveContains(searchText) ||
                $0.origin.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter by type
        if let filter = selectedFilter {
            filtered = filtered.filter { $0.type == filter }
        }
        
        return filtered
    }
    
    private func loadPeppers() {
        peppers = Pepper.samplePeppers
    }
    
    private func loadUnlockedEntries() {
        if let saved = UserDefaults.standard.array(forKey: "unlockedEncyclopediaEntries") as? [String] {
            unlockedEntries = Set(saved)
        } else {
            unlockedEntries = []
        }
    }
    
    private func saveUnlockedEntries() {
        UserDefaults.standard.set(Array(unlockedEntries), forKey: "unlockedEncyclopediaEntries")
    }
    
    func unlockEntry(pepperId: String) {
        unlockedEntries.insert(pepperId)
        saveUnlockedEntries()
        objectWillChange.send()
    }
    
    func isUnlocked(pepper: Pepper) -> Bool {
        return unlockedEntries.contains(pepper.id)
    }
    
    func canUnlock(pepper: Pepper, points: Int) -> Bool {
        return points >= pepper.unlockCost
    }
    
    func formatScoville(_ rating: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: rating)) ?? "\(rating)"
    }
    
    func getScovilleLevel(rating: Int) -> String {
        switch rating {
                case 0: return "Not spicy"
                case 1...700: return "Very mild"
                case 701...3000: return "Mild"
                case 3001...25000: return "Medium"
                case 25001...70000: return "Spicy"
                case 70001...300000: return "Very spicy"
                case 300001...1000000: return "Extreme"
                default: return "Super extreme"
        }
    }
}
extension Pepper {
    var emoji: String {
        switch type {
        case .mild: return "🫑"
        case .medium: return "🌶️"
        case .hot: return "🌶️"
        case .extraHot: return "🔥"
        case .extreme: return "💀"
        }
    }
    
    var heatVisualIndex: Int {
        switch type {
        case .mild: return 1
        case .medium: return 2
        case .hot: return 3
        case .extraHot: return 4
        case .extreme: return 5
        }
    }
}
