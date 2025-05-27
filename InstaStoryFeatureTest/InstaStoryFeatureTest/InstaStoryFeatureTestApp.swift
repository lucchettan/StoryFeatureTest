//
//  InstaStoryFeatureTestApp.swift
//  InstaStoryFeatureTest
//
//  Created by Nicolas Lucchetta on 27/05/2025.
//

import SwiftUI
import SwiftData

@main
struct InstaStoryFeatureTestApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([User.self, StoryItem.self, UserStory.self])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            // Configure the context for better persistence
            let context = container.mainContext
            context.autosaveEnabled = true
            
            let users = try context.fetch(FetchDescriptor<User>())
            let stories = try context.fetch(FetchDescriptor<UserStory>())
            
            // Seed with mocked data if necessary (check both users and stories)
            if users.isEmpty && stories.isEmpty {
                print("🌱 Seeding initial data...")
                SeedData.insertMockData(into: context)
                try context.save() // Ensure seeded data is saved
                print("✅ Initial data seeded successfully")
            } else {
                print("📚 Existing data found - Users: \(users.count), Stories: \(stories.count)")
            }
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
