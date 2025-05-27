//
//  ContentViewModel.swift
//  InstaStoryFeatureTest
//
//  Created by Nicolas Lucchetta on 27/05/2025.
//

import Foundation
import SwiftData

@MainActor
class ContentViewModel: ObservableObject {
    
    @Published var isLoadingAvatarsDone: Bool = false
    @Published var userStories: [UserStory] = []
    @Published var isLoadingMore: Bool = false
    
    @Published var selectedIndex: Int?
    
    func fetchStoriesAndPreloadAvatarImages(context: ModelContext) async {
        let stories = (try? context.fetch(FetchDescriptor<UserStory>())) ?? []
        
        let currentUser = MockedUsers.currentUser
        userStories = stories.ordered(by: currentUser)
        
        for story in userStories {
            guard story.avatarImageData == nil,
                  let url = story.user.avatarURL else { continue }
            
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    continue
                }
                
                story.avatarImageData = data
            } catch {
                print("Failed to load avatar for user \(story.user.name): \(error)")
            }
        }
        
        isLoadingAvatarsDone = true
        
        try? context.save()
    }
    
    func addMockedContent(from context: ModelContext, count: Int = 5) async {
        isLoadingMore = true
        
        SeedData.duplicateRandomStories(from: context, count: count)
        await self.fetchStoriesAndPreloadAvatarImages(context: context)
        
        isLoadingMore = false
    }
}
