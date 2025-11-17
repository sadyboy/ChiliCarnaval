//
//  LeaderboardView.swift
//  PepperQuest
//
//  Leaderboard with scores
//

import SwiftUI

import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
    @State private var showingNameEditor = false
    @State private var tempPlayerName = ""
    let onBack: () -> Void
    
    // Background gradient
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.yellow.opacity(0.4),
                Color.orange.opacity(0.3),
                Color.red.opacity(0.2)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // Header gradient
    private var headerGradient: LinearGradient {
        LinearGradient(
            colors: [.orange.opacity(0.8), .red.opacity(0.7)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var body: some View {
        ZStack {
//            backgroundGradient
//                .ignoresSafeArea()
//            
            VStack(spacing: 0) {
                headerView
                playerNameSection
                sortOptionsView
                contentView
            }
        }
        .onAppear {
            viewModel.loadScores()
            tempPlayerName = viewModel.playerName
        }
        .alert("Edit Player Name", isPresented: $showingNameEditor) {
            TextField("Enter your name", text: $tempPlayerName)
                .autocapitalization(.words)
            
            Button("Cancel", role: .cancel) { }
            Button("Save") {
                viewModel.savePlayerName(tempPlayerName)
            }
        } message: {
            Text("This name will be used for all your game results")
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "arrow.left.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(
                        LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom)
                    )
                    .clipShape(Circle())
                    .shadow(color: .orange.opacity(0.4), radius: 3, x: 0, y: 2)
            }
            
            Spacer()
            
            Text("Leaderboard")
                .font(.custom("PeppaBold", size: 32))
                .foregroundColor(.black)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            
            Spacer()
            
            Image(systemName: "trophy.fill")
                .font(.title2)
                .foregroundColor(.white)
                .padding(8)
                .background(
                    LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom)
                )
                .clipShape(Circle())
                .shadow(color: .yellow.opacity(0.4), radius: 3, x: 0, y: 2)
        }
        .padding()
//        .background(headerGradient)
    }
    
    private var playerNameSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Player Name")
                    .font(.custom("PeppaBold", size: 14))
                    .foregroundColor(.white.opacity(0.8))
                
                HStack(spacing: 8) {
                    Text(viewModel.playerName)
                        .font(.custom("PeppaBold", size: 18))
                        .foregroundColor(.white)
                    
                    Button(action: {
                        tempPlayerName = viewModel.playerName
                        showingNameEditor = true
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                            .background(Color.white.clipShape(Circle()))
                    }
                }
            }
            
            Spacer()
            
            // Player stats summary
            HStack(spacing: 15) {
                PlayerStatBadge(
                    value: "\(viewModel.scores.count)",
                    title: "Games",
                    icon: "gamecontroller.fill",
                    color: .blue
                )
                
                PlayerStatBadge(
                    value: "\(viewModel.topScore?.score ?? 0)",
                    title: "Best",
                    icon: "trophy.fill",
                    color: .yellow
                )
            }
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
        .background(
            LinearGradient(
                colors: [.orange.opacity(0.3), .red.opacity(0.2)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
    
    private var sortOptionsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(LeaderboardViewModel.SortOption.allCases, id: \.self) { option in
                    SortOptionButton(
                        title: option.rawValue,
                        icon: option.icon,
                        isSelected: viewModel.sortOption == option,
                        color: option.color
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.sortOption = option
                            viewModel.sortScores()
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 10)
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.scores.isEmpty {
            emptyStateView
        } else {
            scoresListView
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 25) {
            Spacer()
            
            VStack(spacing: 20) {
                Text("🎮")
                    .font(.system(size: 80))
                
                VStack(spacing: 10) {
                    Text("No Games Played Yet")
                        .font(.custom("PeppaBold", size: 28))
                        .foregroundColor(.white)
                    
                    Text("Play your first game to see your results here!")
                        .font(.custom("PeppaBold", size: 16))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Button(action: {
                onBack()
            }) {
                HStack {
                    Image(systemName: "gamecontroller.fill")
                    Text("Start Playing")
                }
                .font(.custom("PeppaBold", size: 18))
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(
                    LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(25)
                .shadow(color: .orange.opacity(0.5), radius: 10, x: 0, y: 5)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private var scoresListView: some View {
        VStack(spacing: 0) {
            // Top players section for first 3 places
            if viewModel.scores.count >= 3 {
                topPlayersSection
            }
            
            // All scores list
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(Array(viewModel.scores.enumerated()), id: \.element.id) { index, score in
                        if index >= 3 { // Show regular rows starting from 4th place
                            ScoreRow(score: score, rank: index + 1)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical, 10)
            }
            
            // Clear button
            clearButtonView
        }
    }
    
    @ViewBuilder
    private var topPlayersSection: some View {
        if viewModel.scores.count >= 3 {
            VStack(spacing: 15) {
                Text("Top Players")
                    .font(.custom("PeppaBold", size: 24))
                    .foregroundColor(.white)
                    .padding(.top)
                
                HStack(alignment: .bottom, spacing: 10) {
                    // Second place
                    TopPlayerCard(
                        score: viewModel.scores[1],
                        rank: 2,
                        position: .second
                    )
                    
                    // First place
                    TopPlayerCard(
                        score: viewModel.scores[0],
                        rank: 1,
                        position: .first
                    )
                    
                    // Third place
                    TopPlayerCard(
                        score: viewModel.scores[2],
                        rank: 3,
                        position: .third
                    )
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 20)
            
            .background(
                LinearGradient(
                    colors: [.orange.opacity(0.3), .red.opacity(0.2)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
            )
               
                .overlay(
                    RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth:  2)
                     
            )
                .cornerRadius(10)
        }
    }
    
    private var clearButtonView: some View {
        Button(action: {
            viewModel.showClearConfirmation = true
        }) {
            HStack {
                Image(systemName: "trash.fill")
                Text("Clear All Results")
            }
            .font(.custom("PeppaBold", size: 16))
            .foregroundColor(.white)
            .padding(.horizontal, 25)
            .padding(.vertical, 12)
            .background(
                LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(20)
            .shadow(color: .red.opacity(0.4), radius: 5, x: 0, y: 3)
        }
        .padding()
        .alert("Clear All Results?", isPresented: $viewModel.showClearConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                viewModel.clearAllScores()
            }
        } message: {
            Text("This will permanently delete all game results. This action cannot be undone.")
        }
    }


struct PlayerStatBadge: View {
    let value: String
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundColor(color)
                Text(value)
                    .font(.custom("PeppaBold", size: 14))
                    .foregroundColor(.white)
            }
            
            Text(title)
                .font(.custom("PeppaBold", size: 10))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
  
    }
}

  
    
    
    
    private var statsAndActionsView: some View {
        VStack(spacing: 15) {
            // Statistics
            HStack(spacing: 15) {
                StatBadge(
                    title: "Total Games",
                    value: "\(viewModel.scores.count)",
                    icon: "gamecontroller.fill",
                    color: .blue
                )
                
                StatBadge(
                    title: "Best Score",
                    value: "\(viewModel.topScore?.score ?? 0)",
                    icon: "trophy.fill",
                    color: .yellow
                )
                
                StatBadge(
                    title: "Avg Score",
                    value: "\(viewModel.averageScore)",
                    icon: "chart.bar.fill",
                    color: .green
                )
            }
            .padding(.horizontal)
            
            // Clear button
            Button(action: {
                viewModel.showClearConfirmation = true
            }) {
                HStack {
                    Image(systemName: "trash.fill")
                    Text("Clear All Results")
                }
                .font(.custom("PeppaBold", size: 16))
                .foregroundColor(.white)
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(20)
                .shadow(color: .red.opacity(0.4), radius: 5, x: 0, y: 3)
            }
            .padding(.bottom)
        }
        .alert("Clear All Results?", isPresented: $viewModel.showClearConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                viewModel.clearAllScores()
            }
        } message: {
            Text("This will permanently delete all game results. This action cannot be undone.")
        }
    }
}

struct SortOptionButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.custom("PeppaBold", size: 14))
            }
            .foregroundColor(isSelected ? .white : color)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                isSelected ?
                LinearGradient(colors: [color, color.opacity(0.8)], startPoint: .top, endPoint: .bottom) :
                LinearGradient(colors: [Color.white.opacity(0.9), Color.white.opacity(0.8)], startPoint: .top, endPoint: .bottom)
            )
            .cornerRadius(20)
            .shadow(color: isSelected ? color.opacity(0.4) : .black.opacity(0.1), radius: 3, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? color.opacity(0.3) : color.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct TopPlayerCard: View {
    let score: GameScore
    let rank: Int
    let position: PlayerPosition
    
    enum PlayerPosition {
        case first, second, third
        
        var height: CGFloat {
            switch self {
            case .first: return 160
            case .second: return 130
            case .third: return 130
            }
        }
        
        var offset: CGFloat {
            switch self {
            case .first: return -10
            case .second: return 0
            case .third: return 0
            }
        }
        
        var medalColor: LinearGradient {
            switch self {
            case .first:
                return LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom)
            case .second:
                return LinearGradient(colors: [.gray, .gray.opacity(0.7)], startPoint: .top, endPoint: .bottom)
            case .third:
                return LinearGradient(colors: [.orange, .brown], startPoint: .top, endPoint: .bottom)
            }
        }
        
        var medalIcon: String {
            switch self {
            case .first: return "🥇"
            case .second: return "🥈"
            case .third: return "🥉"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Medal
            ZStack {
                Circle()
                    .fill(medalGradient)
                    .frame(width: 60, height: 60)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                
                Text(position.medalIcon)
                    .font(.system(size: 30))
            }
            
            // Player card
            VStack(spacing: 8) {
                Text(score.playerName)
                    .font(.custom("PeppaBold", size: 14))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text("\(score.score)")
                    .font(.custom("PeppaBold", size: 18))
                    .foregroundColor(.yellow)
                
                HStack(spacing: 4) {
                    Image(systemName: "leaf.fill")
                        .font(.caption2)
                        .foregroundColor(.green)
                    Text("\(score.peppersCollected)")
                        .font(.custom("PeppaBold", size: 12))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Text("Lvl \(score.level)")
                    .font(.custom("PeppaBold", size: 11))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(6)
            }
            .padding(10)
            .frame(width: 100)
            .background(playerCardGradient)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
          
        }
        .offset(y: position.offset)
    }
    
    private var medalGradient: LinearGradient {
        position.medalColor
    }
    
    private var playerCardGradient: LinearGradient {
        LinearGradient(
            colors: [.orange.opacity(0.4), .red.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct ScoreRow: View {
    let score: GameScore
    let rank: Int
    
    var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .orange
        default: return .blue
        }
    }
    
    var body: some View {
        HStack(spacing: 15) {
            // Rank
            ZStack {
                Circle()
                    .fill(rankColor.opacity(0.2))
                    .frame(width: 45, height: 45)
                
                Text("\(rank)")
                    .font(.custom("PeppaBold", size: 16))
                    .foregroundColor(rankColor)
            }
            
            // Player info
            VStack(alignment: .leading, spacing: 4) {
                Text(score.playerName)
                    .font(.custom("PeppaBold", size: 16))
                    .foregroundColor(.white)
                
                Text(score.date, style: .date)
                    .font(.custom("PeppaBold", size: 12))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            // Stats
            HStack(spacing: 15) {
                VStack(spacing: 2) {
                    Text("\(score.score)")
                        .font(.custom("PeppaBold", size: 16))
                        .foregroundColor(.yellow)
                    Text("Score")
                        .font(.custom("PeppaBold", size: 10))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                VStack(spacing: 2) {
                    Text("\(score.level)")
                        .font(.custom("PeppaBold", size: 16))
                        .foregroundColor(.blue)
                    Text("Level")
                        .font(.custom("PeppaBold", size: 10))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                VStack(spacing: 2) {
                    HStack(spacing: 2) {
                        Image(systemName: "leaf.fill")
                            .font(.caption2)
                            .foregroundColor(.green)
                        Text("\(score.peppersCollected)")
                            .font(.custom("PeppaBold", size: 16))
                            .foregroundColor(.green)
                    }
                    Text("Peppers")
                        .font(.custom("PeppaBold", size: 10))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .padding(15)
        .background(
            LinearGradient(
                colors: [.orange.opacity(0.3), .red.opacity(0.2)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black, lineWidth: 1)
            
        )
        .cornerRadius(15)
    }
}

struct StatBadge: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            
            Text(value)
                .font(.custom("PeppaBold", size: 18))
                .foregroundColor(.black)
            
            Text(title)
                .font(.custom("PeppaBold", size: 22))
                .foregroundColor(.black.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    LeaderboardView(onBack: {})
}
