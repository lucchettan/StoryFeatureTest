//
//  MockedUsers.swift
//  InstaStoryFeatureTest
//
//  Created by Nicolas Lucchetta on 27/05/2025.
//

import Foundation

struct MockedUsers {
    // DEPRECATED: Use CurrentUserManager.getCurrentUser(from:) instead
    // This is kept for backward compatibility only
    static let currentUser = User(name: "Neo", avatarURL: URL(string: "https://i.pravatar.cc/300?u=1"))
}
