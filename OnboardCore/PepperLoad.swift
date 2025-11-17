import Foundation
import SwiftUI

struct PepperLoad: View {
    @State private var currentImageIndex = 0
    @State private var fadeIn = false
    private let images = ["pep", "pep1","pep2"]
    
    var body: some View {
        ZStack {
            Image(.backMain)
                .resizable()
                .ignoresSafeArea()
            
            if !images.isEmpty {
                VStack(spacing: 100) {
                    Image(images[currentImageIndex])
                        .resizable()
                        .frame(width: 380, height: 480)
                        .opacity(fadeIn ? 1 : 0)
                        .animation(.easeInOut(duration: 1), value: fadeIn)
                        .onAppear {
                            fadeIn = true
                            carnavalLoading()
                        }

                }
            }
        }
    }
    
    // MARK: - Animation Logic
    private func carnavalLoading() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                fadeIn = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                currentImageIndex = (currentImageIndex + 1) % images.count
                withAnimation(.easeInOut(duration: 1)) {
                    fadeIn = true
                }
            }
        }
    }
}

#Preview {
    PepperLoad()
}
