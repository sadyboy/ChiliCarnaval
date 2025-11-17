//
//  ProfileView.swift
//  PepperQuest
//
//  User profile and achievements
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingImagePicker = false
    @State private var showingNameEditor = false
    @State private var tempPlayerName = ""
    @State private var selectedPhoto: PhotosPickerItem?
    
    let onBack: () -> Void
    
    
    // Header gradient
    private var headerGradient: LinearGradient {
        LinearGradient(
            colors: [.orange.opacity(0.8), .red.opacity(0.7)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // Card gradient
    private var cardGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.orange.opacity(0.3),
                Color.red.opacity(0.2)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        ZStack {
//            backgroundGradient
//                .ignoresSafeArea()
            
            mainContent
        }
        .onAppear {
            viewModel.loadProfile()
            tempPlayerName = viewModel.playerName
        }
        .photosPicker(isPresented: $showingImagePicker, selection: $selectedPhoto, matching: .images)
        .onChange(of: selectedPhoto) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    viewModel.saveProfileImage(data)
                }
            }
        }
        .alert("Edit Name", isPresented: $showingNameEditor) {
            TextField("Enter your name", text: $tempPlayerName)
                .autocapitalization(.words)
            
            Button("Cancel", role: .cancel) { }
            Button("Save") {
                viewModel.savePlayerName(tempPlayerName)
            }
        } message: {
            Text("Enter your display name")
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            headerView
            scrollContentView
        }
    }
    
    private var headerView: some View {
        HStack {
            backButton
            Spacer()
            titleView
            Spacer()
            profileIcon
        }
        .padding()
//        .background(headerGradient)
    }
    
    private var backButton: some View {
        Button(action: onBack) {
            Image(systemName: "arrow.left.circle.fill")
                .font(.title2)
                .foregroundColor(.white)
                .padding(8)
                .background(backButtonGradient)
                .clipShape(Circle())
                .shadow(color: .orange.opacity(0.4), radius: 3, x: 0, y: 2)
        }
    }
    
    private var backButtonGradient: LinearGradient {
        LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom)
    }
    
    private var titleView: some View {
        Text("Profile")
            .font(.custom("PeppaBold", size: 32))
            .foregroundColor(.black)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
    }
    
    private var profileIcon: some View {
        Image(systemName: "person.fill")
            .font(.title2)
            .foregroundColor(.white)
            .padding(8)
            .background(profileIconGradient)
            .clipShape(Circle())
         
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black.opacity(0.4), lineWidth: 1)
            )
            .cornerRadius(20)
            .shadow(color: .red.opacity(0.4), radius: 3, x: 0, y: 2)
    }
    
    private var profileIconGradient: LinearGradient {
            LinearGradient(
                colors: [
                    Color.orange.opacity(0.5),
                    Color.red.opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
    
    }
 
    private var scrollContentView: some View {
        ScrollView {
            VStack(spacing: 25) {
                profileHeaderSection
                statsGridSection
                achievementsSection
                gameStatsSection
            }
            .padding(.vertical)
        }
    }
    
    private var profileHeaderSection: some View {
        VStack(spacing: 20) {
            // Avatar with edit button
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    if let profileImage = viewModel.profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(avatarGradient)
                            .frame(width: 120, height: 120)
                            .shadow(color: .orange.opacity(0.4), radius: 10, x: 0, y: 5)
                        
                        Text("🌶️")
                            .font(.system(size: 60))
                    }
                }
                
                // Edit photo button
                Button(action: {
                    showingImagePicker = true
                }) {
                    Image(systemName: "camera.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                }
                .offset(x: -5, y: -5)
                
                // Level badge
                levelBadgeView
                    .offset(x: 5, y: 5)
            }
            
            // Player name with edit button
            VStack(spacing: 8) {
                HStack(spacing: 10) {
                    Text(viewModel.playerName)
                        .font(.custom("PeppaBold", size: 28))
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
                
                Text(getPlayerTitle())
                    .font(.custom("PeppaBold", size: 16))
                    .foregroundColor(.yellow)
                    .italic()
            }
            
            // Delete photo button (only shown if there's a photo)
            if viewModel.profileImage != nil {
                Button(action: {
                    viewModel.deleteProfileImage()
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Remove Photo")
                    }
                    .font(.custom("PeppaBold", size: 14))
                    .foregroundColor(.red)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(20)
                }
            }
        }
        .padding(25)
        .background(cardGradient)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.black.opacity(0.4), lineWidth: 1)
        )
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
        .overlay(cardBorder)
        .padding(.horizontal)
    }
    
    private var avatarGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.orange.opacity(0.5),
                Color.red.opacity(0.8)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var levelBadgeView: some View {
        ZStack {
            Circle()
                .fill(Color.yellow)
                .frame(width: 40, height: 40)
            
            Text("\(viewModel.playerLevel)")
                .font(.custom("PeppaBold", size: 16))
                .foregroundColor(.black)
        }
    }
    
    private func getPlayerTitle() -> String {
        switch viewModel.playerLevel {
        case 1...5:
            return "Spice Beginner"
        case 6...10:
            return "Spice Enthusiast"
        case 11...15:
            return "Spice Master"
        case 16...20:
            return "Spice Champion"
        default:
            return "Spice Legend"
        }
    }
    
    private var statsGridSection: some View {
        LazyVGrid(columns: [GridItem(), GridItem()], spacing: 15) {
            StatCard(
                icon: "trophy.fill",
                title: "High Score",
                value: "\(viewModel.highScore)",
                color: .yellow,
                gradient: [.yellow, .orange]
            )
            
            StatCard(
                icon: "gamecontroller.fill",
                title: "Games Played",
                value: "\(viewModel.gamesPlayed)",
                color: .blue,
                gradient: [.blue, .purple]
            )
            
            StatCard(
                icon: "star.circle.fill",
                title: "Total Points",
                value: "\(viewModel.totalScore)",
                color: .green,
                gradient: [.green, .mint]
            )
            
            StatCard(
                icon: "leaf.fill",
                title: "Peppers Found",
                value: "\(viewModel.totalPeppers)",
                color: .orange,
                gradient: [.orange, .red]
            )
        }
        .padding(25)
        .background(cardGradient)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.black.opacity(0.4), lineWidth: 1)
        )
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
        .overlay(cardBorder)
        .padding(.horizontal)
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            achievementsHeader
            progressBarView
            unlockedAchievementsView
            lockedAchievementsView
        }
        .padding(25)
        .background(cardGradient)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.black.opacity(0.4), lineWidth: 2)
        )
        .cornerRadius(25)
        .overlay(cardBorder)
        .padding(.horizontal)
    }
    
    private var achievementsHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Achievements")
                    .font(.custom("PeppaBold", size: 24))
                    .foregroundColor(.white)
                
                Text("\(viewModel.unlockedAchievements.count)/\(viewModel.achievements.count) unlocked")
                    .font(.custom("PeppaBold", size: 14))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Image(systemName: "medal.fill")
                .font(.title2)
                .foregroundColor(.yellow)
        }
    }
    
    private var progressBarView: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Collection Progress")
                    .font(.custom("PeppaBold", size: 14))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Text(String(format: "%.0f%%", viewModel.completionPercentage))
                    .font(.custom("PeppaBold", size: 14))
                    .foregroundColor(.white)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 16)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(progressGradient)
                        .frame(
                            width: geometry.size.width * (viewModel.completionPercentage / 100),
                            height: 16
                        )
                        .shadow(color: .orange.opacity(0.5), radius: 3, x: 0, y: 2)
                }
            }
            .frame(height: 16)
        }
    }
    
    private var progressGradient: LinearGradient {
        LinearGradient(
            colors: [.yellow, .orange, .red],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    @ViewBuilder
    private var unlockedAchievementsView: some View {
        if !viewModel.unlockedAchievements.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "lock.open.fill")
                        .foregroundColor(.red)
                    Text("Unlocked Achievements")
                        .font(.custom("PeppaBold", size: 18))
                        .foregroundColor(.green)
                }
                
                ForEach(viewModel.unlockedAchievements) { achievement in
                    AchievementCard(achievement: achievement, isUnlocked: true)
                }
            }
        }
    }
    
    @ViewBuilder
    private var lockedAchievementsView: some View {
        if !viewModel.lockedAchievements.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                    Text("Locked Achievements")
                        .font(.custom("PeppaBold", size: 18))
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.top, 10)
                
                ForEach(viewModel.lockedAchievements) { achievement in
                    AchievementCard(achievement: achievement, isUnlocked: false)
                }
            }
        }
    }
    
    private var gameStatsSection: some View {
        VStack(spacing: 15) {
            Text("Game Stats")
                .font(.custom("PeppaBold", size: 22))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 15) {
                MiniStatCard(
                    title: "Win Rate",
                    value: "\(viewModel.winRate)%",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .green
                )
                
                MiniStatCard(
                    title: "Play Time",
                    value: "\(viewModel.playTime)h",
                    icon: "clock.fill",
                    color: .blue
                )
                
                MiniStatCard(
                    title: "Avg Score",
                    value: "\(viewModel.averageScore)",
                    icon: "number.circle.fill",
                    color: .purple
                )
            }
        }
        .padding(20)
        .background(cardGradient)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
    
    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: 25)
            .stroke(Color.orange.opacity(0.4), lineWidth: 1)
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    let gradient: [Color]
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    LinearGradient(colors: gradient, startPoint: .top, endPoint: .bottom)
                )
                .clipShape(Circle())
                .shadow(color: color.opacity(0.5), radius: 5, x: 0, y: 3)
            
            Text(value)
                .font(.custom("PeppaBold", size: 20))
                .foregroundColor(.white)
            
            Text(title)
                .font(.custom("PeppaBold", size: 12))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(15)
        .background(Color.white.opacity(0.1))
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct MiniStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            
            Text(value)
                .font(.custom("PeppaBold", size: 16))
                .foregroundColor(.white)
            
            Text(title)
                .font(.custom("PeppaBold", size: 10))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    let isUnlocked: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            // Achievement icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: isUnlocked ?
                                [.yellow, .orange] :
                                [.gray.opacity(0.3), .gray.opacity(0.5)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Text(achievement.icon)
                    .font(.system(size: 24))
                    .opacity(isUnlocked ? 1 : 0.5)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(achievement.title)
                    .font(.custom("PeppaBold", size: 16))
                    .foregroundColor(isUnlocked ? .white : .white.opacity(0.8))
                
                Text(achievement.description)
                    .font(.custom("PeppaBold", size: 15))
                    .foregroundColor(isUnlocked ? .white.opacity(1.0) : .white.opacity(0.8))
                
                if !isUnlocked {
                    VStack(spacing: 4) {
                        ProgressView(value: Double(achievement.progress), total: Double(achievement.requirement))
                            .tint(.orange)
                            .scaleEffect(x: 1, y: 1.5, anchor: .center)
                        
                        HStack {
                            Text("Progress:")
                                .font(.custom("PeppaBold", size: 15))
                                .foregroundColor(.white.opacity(0.8))
                            Text("\(achievement.progress)/\(achievement.requirement)")
                                .font(.custom("PeppaBold", size: 15))
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    .padding(.top, 4)
                }
            }
            
            Spacer()
            
            if isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
                    .shadow(color: .green.opacity(0.5), radius: 3, x: 0, y: 2)
            } else {
                Image(systemName: "lock.circle.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
        }
        .padding(15)
        .background(
            isUnlocked ?
            LinearGradient(colors: [.green.opacity(0.2), .mint.opacity(0.1)], startPoint: .leading, endPoint: .trailing) :
            LinearGradient(colors: [.gray.opacity(0.1), .gray.opacity(0.05)], startPoint: .leading, endPoint: .trailing)
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isUnlocked ? Color.green.opacity(0.3) : Color.orange,
                    lineWidth: 2
                )
        )
    }
}

#Preview {
    ProfileView(onBack: {})
}
