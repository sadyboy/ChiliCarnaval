import SwiftUI

struct EncyclopediaView: View {
    @StateObject private var viewModel = EncyclopediaViewModel()
    @StateObject private var gameVM = GameViewModel()
    let onBack: () -> Void
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.custom("PeppaBold", size: 28))
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(backButtonGradient)
                            .clipShape(Circle())
                            .shadow(color: .orange.opacity(0.4), radius: 3, x: 0, y: 2)
                    }
                    
                    Spacer()
                    
                    Text("Encyclopedia of Peppers")
                        .font(.custom("PeppaBold", size: 28))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Points display
                    VStack {
                        Text("\(gameVM.encyclopediaPoints)")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                        Text("points")
                            .font(.custom("PeppaBold", size: 12))
                            .foregroundColor(.black)
                    }
                }
                .padding()
                
                
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Searching for peppers...", text: $viewModel.searchText)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding()
                
                // Filter buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        FilterButton(
                            title: "All",
                            isSelected: viewModel.selectedFilter == nil
                        ) {
                            viewModel.selectedFilter = nil
                        }
                        
                        ForEach(PepperType.allCases, id: \.self) { type in
                            FilterButton(
                                title: type.rawValue,
                                color: type.color,
                                isSelected: viewModel.selectedFilter == type
                            ) {
                                viewModel.selectedFilter = type
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Stats summary
                if viewModel.hasUnlockedEntries {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Progress: \(viewModel.unlockedEntries.count)/\(viewModel.peppers.count)")
                                .font(.custom("PeppaBold", size: 14))
                                .foregroundColor(.primary)
                            Text("\(viewModel.completionPercentage)% complete")
                                .font(.custom("PeppaBold", size: 12))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Heat level distribution
                        HStack(spacing: 4) {
                            ForEach(PepperType.allCases, id: \.self) { type in
                                Circle()
                                    .fill(type.color)
                                    .frame(width: 8, height: 8)
                                    .opacity(viewModel.hasUnlockedType(type) ? 1 : 0.3)
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.vertical, 8)
                }
                
                // Pepper list
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.filteredPeppers) { pepper in
                            EnhancedPepperCard(pepper: pepper, viewModel: viewModel, gameVM: gameVM)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            gameVM.loadEncyclopediaPoints()
        }
    }
    private var backButtonGradient: LinearGradient {
        LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom)
    }
}

struct EnhancedPepperCard: View {
    let pepper: Pepper
    let viewModel: EncyclopediaViewModel
    let gameVM: GameViewModel
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with basic info
            HStack(alignment: .top) {
                // Pepper icon with progress ring for locked peppers
                ZStack {
                    if viewModel.isUnlocked(pepper: pepper) {
                        Circle()
                            .fill(pepper.type.color.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Image(pepper.name)
                            .resizable()
                            .frame(width: 40, height: 40)
                    } else {
                        Circle()
                            .stroke(Color.red, lineWidth: 3)
                            .frame(width: 60, height: 60)
                        
                        Text("?")
                            .font(.custom("PeppaBold", size: 24))
                            .foregroundColor(.red)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.isUnlocked(pepper: pepper) ? pepper.name : "???")
                        .font(.custom("PeppaBold", size: 22))
                        .foregroundColor(viewModel.isUnlocked(pepper: pepper) ? .black : .white)
                    
                    if viewModel.isUnlocked(pepper: pepper) {
                        Text(pepper.scientificName)
                            .font(.custom("PeppaBold", size: 15))
                            .italic()
                            .foregroundColor(.white)
                        
                        Text(pepper.origin)
                            .font(.custom("PeppaBold", size: 14))
                            .foregroundColor(.green)
                    } else {
                        Text("Undiscovered")
                            .font(.custom("PeppaBold", size: 15))
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
                // Type badge and unlock cost
                VStack(alignment: .trailing, spacing: 8) {
                    if viewModel.isUnlocked(pepper: pepper) {
                        Text(pepper.type.rawValue)
                            .font(.custom("PeppaBold", size: 14))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(pepper.type.color)
                            .cornerRadius(8)
                    } else {
                        VStack(spacing: 2) {
                            Image(systemName: "star.circle.fill")
                                .font(.caption)
                                .foregroundColor(.blue)
                            Text("\(pepper.unlockCost)")
                                .font(.custom("PeppaBold", size: 12))
                                .foregroundColor(.green)
                            Text("points")
                                .font(.custom("PeppaBold", size: 12))
                                .foregroundColor(.white)
                        }
                        .padding(6)
//                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
            
            if viewModel.isUnlocked(pepper: pepper) {
                // Scoville Scale with visual indicator
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.red)
                        Text("Heat Level")
                            .font(.custom("PeppaBold", size: 15))
                            .foregroundColor(.red)
                        
                        Spacer()
                        
                        Text(viewModel.getScovilleLevel(rating: pepper.scovilleRating))
                            .font(.custom("PeppaBold", size: 14))
                            .foregroundColor(pepper.type.color)
                    }
                    
                    // Visual scoville meter
                    HStack {
                        ForEach(0..<6, id: \.self) { index in
                            Rectangle()
                                .fill(index < pepper.heatVisualIndex ? pepper.type.color : Color.gray.opacity(0.3))
                                .frame(height: 6)
                                .cornerRadius(3)
                        }
                    }
                    
                    HStack {
                        Text("\(viewModel.formatScoville(pepper.scovilleRating)) SHU")
                            .font(.custom("PeppaBold", size: 14))
                            .foregroundColor(.red)
                        
                        Spacer()
                        
                        Text("Scoville Scale")
                            .font(.custom("PeppaBold", size: 14))
                            .foregroundColor(.red)
                    }
                }
                .padding(.vertical, 4)
                
                // Quick facts
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    FactItem(icon: "leaf.fill", color: .green, title: "Species", value: pepper.family)
                    FactItem(icon: "globe", color: .blue, title: "Region", value: pepper.region)
                    FactItem(icon: "ruler", color: .purple, title: "Size", value: pepper.size)
                    FactItem(icon: "clock", color: .orange, title: "Growth", value: pepper.growthTime)
                }
                
                // Expandable section
                Button(action: { withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }}) {
                    HStack {
                        Text(isExpanded ? "Show Less" : "Discover More")
                            .font(.custom("PeppaBold", size: 18))
                            .foregroundColor(.black)
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .foregroundColor(.orange)
                }
                .padding(.top, 4)
                
                if isExpanded {
                    VStack(alignment: .leading, spacing: 12) {
                        Divider()
                        
                        // Description
                        Text(pepper.description)
                            .font(.custom("PeppaBold", size: 16))
                            .foregroundColor(.white)
                            .lineSpacing(2)
                        
                        // Usage and characteristics
                        if !pepper.commonUses.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Common Uses")
                                    .font(.custom("PeppaBold", size: 14))
                                    .foregroundColor(.primary)
                                
                                FlowLayout(spacing: 6) {
                                    ForEach(pepper.commonUses, id: \.self) { use in
                                        Text(use)
                                            .font(.custom("PeppaBold", size: 16))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.blue.opacity(0.1))
                                            .foregroundColor(.blue)
                                            .cornerRadius(6)
                                    }
                                }
                            }
                        }
                        
                        // Fun fact
                        if !pepper.funFact.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(.white)
                                    Text("Did You Know?")
                                        .font(.custom("PeppaBold", size: 14))
                                        .foregroundColor(.white)
                                }
                                
                                Text(pepper.funFact)
                                    .font(.custom("PeppaBold", size: 13))
                                    .foregroundColor(.white)
                                    .italic()
                            }
                            .padding()
                            .background(Color.yellow.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            } else {
                // Unlock section for locked peppers
                VStack(spacing: 12) {
                    Text("Unlock to discover this pepper's secrets!")
                        .font(.custom("PeppaBold", size: 13))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        if gameVM.unlockEncyclopediaEntry(cost: pepper.unlockCost) {
                            viewModel.unlockEntry(pepperId: pepper.id)
                        }
                    }) {
                        HStack {
                            Image(systemName: "lock.open.fill")
                            Text("Unlock for \(pepper.unlockCost) points")
                        }
                        .font(.custom("PeppaBold", size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            viewModel.canUnlock(pepper: pepper, points: gameVM.encyclopediaPoints) ?
                            LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing) :
                            LinearGradient(colors: [.gray], startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(20)
                        .shadow(color: .white.opacity(0.1), radius: 2, x: 0, y: 1)
                    }
                    .disabled(!viewModel.canUnlock(pepper: pepper, points: gameVM.encyclopediaPoints))
                }
                .padding(.vertical, 8)
            }
        }
        .padding()
        .background(
                LinearGradient(
                    colors: [
                        Color.orange.opacity(0.5),
                        Color.red.opacity(0.8)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
        )
        .overlay(content: {
            RoundedRectangle(cornerRadius: 18).stroke(Color.black, lineWidth: 2)
        })
        .cornerRadius(18)
        .shadow(color: .white.opacity(0.1), radius: 8, x: 0, y: 3)
    }
}

// Supporting views
struct FactItem: View {
    let icon: String
    let color: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("PeppaBold", size: 15))
                    .foregroundColor(.white)
                Text(value)
                    .font(.custom("PeppaBold", size: 14))
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding(6)
        .background(color.opacity(0.1))
        .cornerRadius(6)
    }
}

// Flow layout for tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return layout(sizes: sizes, containerWidth: width).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let result = layout(sizes: sizes, containerWidth: bounds.width)
        for (index, subview) in subviews.enumerated() {
            let point = result.points[index]
            subview.place(at: CGPoint(x: point.x + bounds.minX, y: point.y + bounds.minY), proposal: .unspecified)
        }
    }
    
    private func layout(sizes: [CGSize], containerWidth: CGFloat) -> (points: [CGPoint], size: CGSize) {
        var x: CGFloat = 0
        var y: CGFloat = 0
        var maxHeight: CGFloat = 0
        var points: [CGPoint] = []
        
        for size in sizes {
            if x + size.width > containerWidth {
                x = 0
                y += maxHeight + spacing
                maxHeight = 0
            }
            points.append(CGPoint(x: x, y: y))
            x += size.width + spacing
            maxHeight = max(maxHeight, size.height)
        }
        
        return (points, CGSize(width: containerWidth, height: y + maxHeight))
    }
}
