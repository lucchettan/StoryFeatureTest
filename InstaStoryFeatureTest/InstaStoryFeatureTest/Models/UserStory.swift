//
//  UserStory.swift
//  InstaStoryFeatureTest
//
//  Created by Nicolas Lucchetta on 27/05/2025.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class UserStory: Identifiable {
    var id: UUID
    var user: User
    @Relationship var items: [StoryItem]
    var avatarImageData: Data?

    init(id: UUID = UUID(), user: User, items: [StoryItem] = []) {
        self.id = id
        self.user = user
        self.items = items
        self.avatarImageData = nil
    }
    
    var avatarImage: UIImage? {
        guard let data = avatarImageData else { return nil }
        return UIImage(data: data)
    }
}

// Extensions
extension UserStory {
    func firstUnseenItemIndex(for user: User) -> Int {
        items.firstIndex { item in
            !item.seenBy.contains(where: { $0.id == user.id })
        } ?? 0
    }
    
    func hasUnseenItems(by user: User) -> Bool {
        self.items.contains { item in
            !item.seenBy.contains(where: { $0.id == user.id })
        }
    }
}

extension Array where Element == UserStory {

    func ordered(by user: User) -> [UserStory] {
        self.unseen(by: user) + self.seen(by: user)
    }
    
    func unseen(by user: User) -> [UserStory] {
        self
            .filter { story in
                story.items.contains { item in
                    !item.seenBy.contains(where: { $0.id == user.id })
                }
            }
            .sortedByRecent()
    }

    func seen(by user: User) -> [UserStory] {
        self
            .filter { story in
                story.items.allSatisfy { item in
                    item.seenBy.contains(where: { $0.id == user.id })
                }
            }
            .sortedByRecent()
    }

    func sortedByRecent() -> [UserStory] {
        self.sorted {
            let lhsDate = $0.items.map(\.date).max() ?? .distantPast
            let rhsDate = $1.items.map(\.date).max() ?? .distantPast
            return lhsDate > rhsDate
        }
    }
}
