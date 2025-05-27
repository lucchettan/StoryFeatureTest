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
    
    init(userStories: [UserStory], initialStoryIndex: Int = 0, modelContext: ModelContext, onDismiss: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: StoriesExplorerViewModel(
            userStories: userStories,
            initialStoryIndex: initialStoryIndex,
            modelContext: modelContext
        ))
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundImage(geometry: geometry)
                
                overlayContent
                
                gestureHandler(geometry: geometry)
            }
        }
//        .onAppear {
//            viewModel.startProgress()
//        }
        .onDisappear {
            viewModel.stopProgress()
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
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .aspectRatio(contentMode: .fill)
                            .onAppear {
                                viewModel.onImageLoaded()
                            }
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
            
            topBar
            
            Spacer()
            
            bottomBar
        }
        .padding(.vertical, 40)
    }
    
    private var progressIndicators: some View {
        HStack(spacing: 4) {
            ForEach(0..<viewModel.getProgressIndicatorStates().count, id: \.self) { index in
                Capsule()
                    .fill(progressColor(for: viewModel.getProgressIndicatorStates()[index]))
                    .frame(height: 3)
                    .overlay(alignment: .leading) {
                        if viewModel.getProgressIndicatorStates()[index] == .current {
                            Capsule()
                                .fill(.white)
                                .frame(height: 3)
                                .frame(width: 10/* try to go from 0 to full in  */)
                        }
                    
                    }
            }
        }
        .padding(.horizontal)
    }
    
    private func progressColor(for state: ProgressIndicatorState) -> Color {
        switch state {
        case .completed:
            return .white
        case .current:
            return .orange // Could be instagram gradient here
        case .upcoming:
            return .gray.opacity(0.5)
        }
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
                .font(.headline)
            
            Spacer()
            
            Button(action: {
                viewModel.stopProgress()
                onDismiss()
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal)
    }
    
    private var bottomBar: some View {
        HStack {
            Spacer()
            
            Button(action: {
                viewModel.toggleLike()
            }) {
                Image(systemName: viewModel.isCurrentItemLiked ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(viewModel.isCurrentItemLiked ? .red : .white)
            }
        }
        .padding(.horizontal)
    }
    
    private func gestureHandler(geometry: GeometryProxy) -> some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture { location in
                viewModel.handleTapGesture(at: location, in: geometry)
            }
            .gesture(
                DragGesture()
                    .onChanged { _ in
                        viewModel.pauseProgress()
                    }
                    .onEnded { value in
                        let horizontalDistance = value.translation.width
                        let verticalDistance = value.translation.height
                        
                        if abs(verticalDistance) > abs(horizontalDistance) {
                            // Vertical swipe
                            if verticalDistance > 100 {
                                // Swipe down - dismiss
                                viewModel.stopProgress()
                                onDismiss()
                                dismiss()
                            } else {
                                viewModel.resumeProgress()
                            }
                        } else {
                            // Horizontal swipe
                            if horizontalDistance > 100 {
                                // Swipe right - previous story
                                viewModel.navigateToPreviousStory()
                            } else if horizontalDistance < -100 {
                                // Swipe left - next story
                                viewModel.navigateToNextStory()
                            } else {
                                viewModel.resumeProgress()
                            }
                        }
                    }
            )
    }
}
