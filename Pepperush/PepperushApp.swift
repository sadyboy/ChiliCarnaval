import SwiftUI


struct PepperushApp: View {
    @StateObject private var dataManager = DataManager.shared

    var body: some View {
        VStack {
            MainMenuView()
                .environmentObject(dataManager)
        }
    }
}
