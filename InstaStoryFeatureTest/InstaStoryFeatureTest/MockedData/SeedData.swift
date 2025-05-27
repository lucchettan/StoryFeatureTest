//
//  MockedData.swift
//  InstaStoryFeatureTest
//
//  Created by Nicolas Lucchetta on 27/05/2025.
//

import SwiftData
import Foundation

enum SeedData {
    
    // MARK: - Random Data Sources
    static let firstNames = [
        "Alex", "Jordan", "Casey", "Riley", "Morgan", "Avery", "Quinn", "Sage", "River", "Phoenix",
        "Rowan", "Skylar", "Cameron", "Blake", "Emery", "Finley", "Hayden", "Kendall", "Logan", "Parker",
        "Taylor", "Jamie", "Drew", "Reese", "Charlie", "Dakota", "Peyton", "Sydney", "Alexis", "Jesse",
        "Sam", "Kai", "Remy", "Ari", "Ash", "Bay", "Blue", "Bryn", "Cedar", "Dove", "Echo", "Fern",
        "Gray", "Indigo", "Juno", "Lane", "Lux", "Nova", "Ocean", "Rain", "Scout", "Wren"
    ]
    
    static let lastNames = [
        "Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez",
        "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson", "Thomas", "Taylor", "Moore", "Jackson", "Martin",
        "Lee", "Perez", "Thompson", "White", "Harris", "Sanchez", "Clark", "Ramirez", "Lewis", "Robinson",
        "Walker", "Young", "Allen", "King", "Wright", "Scott", "Torres", "Nguyen", "Hill", "Flores",
        "Green", "Adams", "Nelson", "Baker", "Hall", "Rivera", "Campbell", "Mitchell", "Carter", "Roberts"
    ]
    
    // MARK: - Main Methods
    static func insertMockData(into context: ModelContext) {
        generateRandomUserStories(into: context, count: 5)
    }
    
    // MARK: - Core Generation Logic
    private static func generateRandomUserStories(into context: ModelContext, count: Int) {
        // Get existing users for interactions
        let existingUsers = (try? context.fetch(FetchDescriptor<UserStory>())) ?? []
        let existingUsersList = existingUsers.map { $0.user }
        
        // Generate new random users
        let newUsers = generateRandomUsers(count: count)
        
        // Create user stories for each new user
        let newUserStories = newUsers.map { user in
            UserStory(
                user: user,
                items: generateRandomStoryItems(
                    for: user,
                    existingUsers: existingUsersList + newUsers
                )
            )
        }
        
        // Insert everything into context
        for user in newUsers {
            context.insert(user)
        }
        
        for story in newUserStories {
            context.insert(story)
        }
        
        try? context.save()
    }
    
    private static func generateRandomUsers(count: Int) -> [User] {
        var usedNames = Set<String>()
        var users: [User] = []
        
        while users.count < count {
            let firstName = firstNames.randomElement()!
            let lastName = lastNames.randomElement()!
            let fullName = "\(firstName) \(lastName)"
            
            // Ensure unique names
            if !usedNames.contains(fullName) {
                usedNames.insert(fullName)
                
                let randomAvatarID = Int.random(in: 1000...9999)
                let user = User(
                    name: fullName,
                    avatarURL: URL(string: "https://i.pravatar.cc/300?u=\(randomAvatarID)")
                )
                users.append(user)
            }
        }
        
        return users
    }
    
    private static func generateRandomStoryItems(for owner: User, existingUsers: [User]) -> [StoryItem] {
        let itemCount = Int.random(in: 1...4)
        let others = existingUsers.filter { $0.id != owner.id }
        
        return (0..<itemCount).map { i in
            let randomImageID = Int.random(in: 100...999)
            let imageURL = "https://picsum.photos/id/\(randomImageID)/400/600"
            
            // Random interactions
            let seenByCount = Int.random(in: 0...min(5, others.count))
            let likedByCount = Int.random(in: 0...min(3, others.count))
            
            let seenBy = Array(others.shuffled().prefix(seenByCount))
            let likedBy = Array(others.shuffled().prefix(likedByCount))
            
            // Random time in the past (up to 24 hours ago)
            let randomTimeAgo = Double.random(in: 0...(24 * 3600)) + Double(i * 1800)
            
            return StoryItem(
                seenBy: seenBy,
                likedBy: likedBy,
                imageURL: imageURL,
                date: Date().addingTimeInterval(-randomTimeAgo)
            )
        }
    }
}
