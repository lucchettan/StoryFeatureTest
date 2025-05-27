//
//  User.swift
//  InstaStoryFeatureTest
//
//  Created by Nicolas Lucchetta on 27/05/2025.
//

import Foundation
import SwiftData

@Model
class User: Identifiable {
    var id: UUID
    var name: String
    var avatarURL: URL?

    init(id: UUID = UUID(), name: String, avatarURL: URL? = nil) {
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
    }
}
