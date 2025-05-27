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
    
    // MARK: - Navigation
    
    func navigateToNext() {
        guard let story = currentStory else { return }

        DispatchQueue.main.async { markCurrentItemAsSeen() }
        
        // Check if there's a next item in current story
        if storyItemIndex < story.items.count - 1 {
            storyItemIndex += 1
        } else {
            // Move to next story
            navigateToNextStory()
        }
    }
    
    func navigateToPrevious() {

        // Check if there's a previous item in current story
        if storyItemIndex > 0 {
            storyItemIndex -= 1
        } else {
            // Move to previous story
            navigateToPreviousStory()
        }
    }
    
    func navigateToNextStory() {
        markCurrentItemAsSeen()

        if storyIndex < userStories.count - 1 {
            storyIndex += 1
            storyItemIndex = userStories[storyIndex].firstUnseenItemIndex(for: currentUser)
        } else {
            // End of stories - could trigger dismiss or loop
        }
    }
    
    func navigateToPreviousStory() {
        if storyIndex > 0 {
            storyIndex -= 1
            storyItemIndex = 0
        } else {
            // dismiss if there's no previous story
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
    
    func onImageLoadFailed() {
        navigateToNext()
    }
    
    func onImageLoadEmpty() {
        navigateToNext()
    }
    
    // MARK: - Gesture Handling
    
    func handleTapGesture(at location: CGPoint, in geometry: GeometryProxy) {
        let screenWidth = geometry.size.width
        
        // Tapped left side - go to previous otherwise go to next
        if location.x < screenWidth / 2 {
            navigateToPrevious()
        } else {
            navigateToNext()
        }
    }
}
