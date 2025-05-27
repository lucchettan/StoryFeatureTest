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
    
    static let mockedPage1: [User] = [
        User(name: "Trinity", avatarURL: URL(string: "https://i.pravatar.cc/300?u=2")),
        User(name: "Morpheus", avatarURL: URL(string: "https://i.pravatar.cc/300?u=3")),
        User(name: "Smith", avatarURL: URL(string: "https://i.pravatar.cc/300?u=4")),
        User(name: "Oracle", avatarURL: URL(string: "https://i.pravatar.cc/300?u=5")),
        User(name: "Cypher", avatarURL: URL(string: "https://i.pravatar.cc/300?u=6")),
        User(name: "Niobe", avatarURL: URL(string: "https://i.pravatar.cc/300?u=7")),
        User(name: "Dozer", avatarURL: URL(string: "https://i.pravatar.cc/300?u=8")),
        User(name: "Switch", avatarURL: URL(string: "https://i.pravatar.cc/300?u=9")),
        User(name: "Tank", avatarURL: URL(string: "https://i.pravatar.cc/300?u=10"))
    ]

    static let mockedPage2: [User] = [
        User(name: "Seraph", avatarURL: URL(string: "https://i.pravatar.cc/300?u=11")),
        User(name: "Sati", avatarURL: URL(string: "https://i.pravatar.cc/300?u=12")),
        User(name: "Merovingian", avatarURL: URL(string: "https://i.pravatar.cc/300?u=13")),
        User(name: "Persephone", avatarURL: URL(string: "https://i.pravatar.cc/300?u=14")),
        User(name: "Ghost", avatarURL: URL(string: "https://i.pravatar.cc/300?u=15")),
        User(name: "Lock", avatarURL: URL(string: "https://i.pravatar.cc/300?u=16")),
        User(name: "Rama", avatarURL: URL(string: "https://i.pravatar.cc/300?u=17")),
        User(name: "Bane", avatarURL: URL(string: "https://i.pravatar.cc/300?u=18")),
        User(name: "The Keymaker", avatarURL: URL(string: "https://i.pravatar.cc/300?u=19")),
        User(name: "Commander Thadeus", avatarURL: URL(string: "https://i.pravatar.cc/300?u=20"))
    ]

    static let mockedPage3: [User] = [
        User(name: "Kid", avatarURL: URL(string: "https://i.pravatar.cc/300?u=21")),
        User(name: "Zee", avatarURL: URL(string: "https://i.pravatar.cc/300?u=22")),
        User(name: "Mifune", avatarURL: URL(string: "https://i.pravatar.cc/300?u=23")),
        User(name: "Roland", avatarURL: URL(string: "https://i.pravatar.cc/300?u=24")),
        User(name: "Cas", avatarURL: URL(string: "https://i.pravatar.cc/300?u=25")),
        User(name: "Colt", avatarURL: URL(string: "https://i.pravatar.cc/300?u=26")),
        User(name: "Vector", avatarURL: URL(string: "https://i.pravatar.cc/300?u=27")),
        User(name: "Sequoia", avatarURL: URL(string: "https://i.pravatar.cc/300?u=28")),
        User(name: "Sentinel", avatarURL: URL(string: "https://i.pravatar.cc/300?u=29")),
        User(name: "Turing", avatarURL: URL(string: "https://i.pravatar.cc/300?u=30"))
    ]
}
