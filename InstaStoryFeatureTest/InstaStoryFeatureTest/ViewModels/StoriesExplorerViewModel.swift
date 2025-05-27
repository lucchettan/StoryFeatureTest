 //
//  StoriesExplorerViewModel.swift
//  InstaStoryFeatureTest
//
//  Created by Nicolas Lucchetta on 27/05/2025.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class StoriesExplorerViewModel: ObservableObject {
    
    @Published var storyIndex: Int = 0
    @Published var storyItemIndex: Int = 0
    @Published var isImageLoaded: Bool = false
    @Published var progressTimer: Timer?
    
    private var userStories: [UserStory]
    private var currentUser : User = MockedUsers.currentUser
    private var modelContext: ModelContext
    
    init(userStories: [UserStory], initialStoryIndex: Int = 0, modelContext: ModelContext) {
        self.userStories = userStories
        self.storyIndex = initialStoryIndex
        self.modelContext = modelContext
        
        // Set initial story item index to first unseen item
        if !userStories[storyIndex].items.isEmpty {
            self.storyItemIndex = userStories[initialStoryIndex].firstUnseenItemIndex(for: currentUser)
        }
    }
    
    // MARK: UI purposed values
    var currentStory: UserStory? {
        guard storyIndex < userStories.count else { return nil }
        return userStories[storyIndex]
    }
    
    var currentStoryItem: StoryItem? {
        guard let story = currentStory,
              storyItemIndex < story.items.count else { return nil }
        return story.items[storyItemIndex]
    }
    
    var currentImageURL: URL? {
        guard let item = currentStoryItem else { return nil }
        return URL(string: item.imageURL)
    }
    
    var isCurrentItemLiked: Bool {
        guard let item = currentStoryItem else { return false }
        return item.likedBy.contains(where: { $0.id == currentUser.id })
    }
    
    // MARK: - Progress Management
    
    func startProgress() {
        stopProgress()
        progressTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            self?.navigateToNext()
        }
    }
    
    func stopProgress() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
    
    func pauseProgress() {
        stopProgress()
    }
    
    func resumeProgress() {
        startProgress()
    }
    
    // MARK: - Navigation
    
    func navigateToNext() {
        guard let story = currentStory else { return }
        
        // Mark current item as seen
        markCurrentItemAsSeen()
        
        // Check if there's a next item in current story
        if storyItemIndex < story.items.count - 1 {
            storyItemIndex += 1
            startProgress()
        } else {
            // Move to next story
            navigateToNextStory()
        }
    }
    
    func navigateToPrevious() {
        // Check if there's a previous item in current story
        if storyItemIndex > 0 {
            storyItemIndex -= 1
            startProgress()
        } else {
            // Move to previous story
            navigateToPreviousStory()
        }
    }
    
    func navigateToNextStory() {
        if storyIndex < userStories.count - 1 {
            storyIndex += 1
            storyItemIndex = userStories[storyIndex].firstUnseenItemIndex(for: currentUser)
            startProgress()
        } else {
            // End of stories - could trigger dismiss or loop
            stopProgress()
        }
    }
    
    func navigateToPreviousStory() {
        if storyIndex > 0 {
            storyIndex -= 1
            storyItemIndex = 0
            startProgress()
        }
    }
    
    // MARK: - User Interactions
    
    func toggleLike() {
        guard let item = currentStoryItem else { return }
        
        if let existingIndex = item.likedBy.firstIndex(where: { $0.id == currentUser.id }) {
            item.likedBy.remove(at: existingIndex)
        } else {
            item.likedBy.append(currentUser)
        }
        
        try? modelContext.save()
    }
    
    func markCurrentItemAsSeen() {
        guard let item = currentStoryItem else { return }
        
        if !item.seenBy.contains(where: { $0.id == currentUser.id }) {
            item.seenBy.append(currentUser)
            try? modelContext.save()
        }
    }
    
    // MARK: - Image Loading
    
    func onImageLoaded() {
        isImageLoaded = true
        markCurrentItemAsSeen()
        startProgress()
    }
    
    func onImageLoadFailed() {
        isImageLoaded = false
        // Continue to next even if image failed
        navigateToNext()
    }
    
    func onImageLoadEmpty() {
        isImageLoaded = false
        // Skip to next immediately
        navigateToNext()
    }
    
    // MARK: - Gesture Handling
    
    func handleTapGesture(at location: CGPoint, in geometry: GeometryProxy) {
        let screenWidth = geometry.size.width
        
        if location.x < screenWidth / 2 {
            // Tapped left side - go to previous
            navigateToPrevious()
        } else {
            // Tapped right side - go to next
            navigateToNext()
        }
    }
    
    // MARK: - Progress Indicators Data
    
    func getProgressIndicatorStates() -> [ProgressIndicatorState] {
        guard let story = currentStory else { return [] }
        
        return story.items.enumerated().map { index, item in
            if index < storyItemIndex {
                return .completed
            } else if index == storyItemIndex {
                return .current
            } else {
                return .upcoming
            }
        }
    }
    
    // MARK: - Cleanup
    
    func cleanup() {
        stopProgress()
    }
}

enum ProgressIndicatorState {
    case completed
    case current
    case upcoming
}
