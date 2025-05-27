//
//  UserStoryCell.swift
//  InstaStoryFeatureTest
//
//  Created by Nicolas Lucchetta on 27/05/2025.
//

import SwiftUI

struct UserStoryCell: View {
    var userStory: UserStory
    var currentUser: User
    
    var body: some View {
        if let avatarImage = userStory.avatarImage {
            Image(uiImage: avatarImage)
                .resizable()
                .clipShape(Circle())
                .frame(width: 80, height: 80)
                .overlay(
                    Circle()
                        .stroke(
                            userStory.hasUnseenItems(by: currentUser) ? Colors.instagramGradient : Colors.unseenGradient,
                            lineWidth: 3.5
                        )
                        .frame(width: 90, height: 90)
                )
                .padding(.horizontal, 5)
        }
    }
}
