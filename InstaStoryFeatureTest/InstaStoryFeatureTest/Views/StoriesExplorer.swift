//
//  StoriesExplorer.swift
//  InstaStoryFeatureTest
//
//  Created by Nicolas Lucchetta on 27/05/2025.
//

import SwiftData
import SwiftUI

struct StoriesExplorer: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: StoriesExplorerViewModel
    var onDismiss: () -> Void
    
    @State private var progress: Double = 0.0
    @State private var timer: Timer? = nil
    @State private var isAnimatingLike: Bool = false

    init(userStories: [UserStory], initialStoryIndex: Int = 0, onDismiss: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: StoriesExplorerViewModel(
            userStories: userStories,
            initialStoryIndex: initialStoryIndex
        ))
        self.onDismiss = onDismiss
    }
        
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundImage(geometry: geometry)
                    .frame(width: geometry.size.width, height: geometry.size.height * 1.2)
                    .clipped()
                
                gestureHandler(geometry: geometry)

                overlayContent
            }
            .ignoresSafeArea(.all)
        }
        .onAppear {
            viewModel.setup(context: modelContext)
        }
        .onDisappear {
            stopProgress()
        }
    }
    
    private func backgroundImage(geometry: GeometryProxy) -> some View {
        Group {
            if let imageURL = viewModel.currentImageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .onAppear {
                                DispatchQueue.main.async {
                                    startProgress()
                                }
                            }
                            .id(imageURL)
                    case .failure(_):
                        VStack {
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                            Text("Failed to load image")
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black)
                        .onAppear {
                            viewModel.onImageLoadFailed()
                        }
                    case .empty:
                        ZStack {
                            Color.black
                            ProgressView()
                                .tint(.white)
                        }
                        .onAppear {
                            viewModel.onImageLoadEmpty()
                        }
                    @unknown default:
                        Color.black
                    }
                }
            } else {
                Color.black
            }
        }
    }
    
    private var overlayContent: some View {
        VStack {
            progressIndicators
                .padding(.top, 20)
            topBar
            
            Spacer()
            
            bottomBar
        }
        .padding(.vertical, 40)
    }
    
    private var progressIndicators: some View {
        HStack(spacing: 4) {
            ForEach(0..<(viewModel.currentStory?.items.count ?? 0), id: \.self) { index in
                GeometryReader { geo in
                    Capsule()
                        .fill(index < viewModel.storyItemIndex ? .white : .gray)
                        .frame(height: 3)
                        .overlay(alignment: .leading) {
                            if index == viewModel.storyItemIndex {
                                Capsule()
                                    .fill(.white)
                                    .frame(height: 3)
                                    .frame(width: geo.size.width * progress)
                            }
                        }
                }
            }
        }
        .frame(height: 5)
        .padding(.horizontal)
    }
    
    private var topBar: some View {
        HStack {
            if let avatarImage = viewModel.currentStory?.avatarImage {
                Image(uiImage: avatarImage)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)
            }
            
            Text(viewModel.currentStory?.user.name ?? "")
                .foregroundColor(.white)
                .lineLimit(1)
                .font(.headline)
            
            Spacer()
            
            Button(action: {
                stopProgress()
                onDismiss()
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
            }
        }
        .background(
            Color.black
                .opacity(0.001)
                .frame(height: 40)
        )
        .padding()
    }
    
    var bottomBar: some View {
        HStack {
            Spacer()
            
            Button(action: {
                likeAction()
            }) {
                Image(systemName: viewModel.isCurrentItemLiked ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(viewModel.isCurrentItemLiked ? .red : .white)
                    .scaleEffect(isAnimatingLike ? 1.3 : 1.0)
                    .animation(.easeOut(duration: 0.2), value: isAnimatingLike)
                    .padding()
                    .background(
                        Color.black
                            .opacity(0.001)
                            .frame(width: 60, height: 60)
                    )
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 50)
    }
    
    private func gestureHandler(geometry: GeometryProxy) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
            }
        }
        .background(Color.clear)
        .contentShape(Rectangle())
        .allowsHitTesting(true)
        .onTapGesture { location in
            viewModel.handleTapGesture(at: location, in: geometry)
            stopProgress()
        }
        .gesture(
            DragGesture()
                .onChanged { _ in
                    pauseProgress()
                }
                .onEnded { value in
                    let horizontalDistance = value.translation.width
                    let verticalDistance = value.translation.height
                    if abs(verticalDistance) > abs(horizontalDistance) {
                        if verticalDistance > 100 {
                            stopProgress()
                            onDismiss()
                            dismiss()
                        } else {
                            resumeProgress()
                        }
                    } else {
                        if horizontalDistance > 100 {
                            stopProgress()
                            viewModel.navigateToPreviousStory()
                        } else if horizontalDistance < -100 {
                            stopProgress()
                            viewModel.navigateToNextStory()
                        } else {
                            resumeProgress()
                        }
                    }
                }
        )
    }
    
    // MARK: Progress logic within the view to avoid concurrencies issues
    private func startProgress() {
        stopProgress()
        progress = 0.0
        let interval = 0.02
        let totalDuration = 5.0
        var elapsed = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { activeTimer in
            elapsed += interval
            progress = min(elapsed / totalDuration, 1.0)
            if progress >= 1.0 {
                stopProgress()
                
                // Fixed: use Task/Mainactor to ensure both methods run safely on the main thread and removes the Swift 6 isolation warning
                Task { @MainActor in
                    viewModel.navigateToNext()
                }
            }
        }
    }
    
    private func stopProgress() {
        guard timer != nil else { return }
        timer?.invalidate()
        timer = nil
    }
    
    private func pauseProgress() {
        stopProgress()
    }
    
    private func resumeProgress() {
        startProgress()
    }
    
    // MARK: Custom Like action
    
    private func likeAction() {
        viewModel.toggleLike()
        // Trigger scale animation
        isAnimatingLike = true
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isAnimatingLike = false
        }
    }
}
