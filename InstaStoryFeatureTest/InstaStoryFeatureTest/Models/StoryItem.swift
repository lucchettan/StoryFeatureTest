//
//  StoryItem.swift
//  InstaStoryFeatureTest
//
//  Created by Nicolas Lucchetta on 27/05/2025.
//

import Foundation
import SwiftData

@Model
class StoryItem: Identifiable {
    var id: UUID
    var seenBy: [User]
    var likedBy: [User]
    var imageURL: String
    var date: Date
    
    init(
        id: UUID = UUID(),
        seenBy: [User] = [],
        likedBy: [User] = [],
        imageURL: String,
        date: Date = Date()
    ) {
        self.id = id
        self.seenBy = seenBy
        self.likedBy = likedBy
        self.imageURL = imageURL
        self.date = date
    }
}
