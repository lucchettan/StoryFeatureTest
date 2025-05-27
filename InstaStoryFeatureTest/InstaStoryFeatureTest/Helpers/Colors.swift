//
//  Colors.swift
//  InstaStoryFeatureTest
//
//  Created by Nicolas Lucchetta on 27/05/2025.
//

import SwiftUI

struct Colors {
    static let instagramGradient = LinearGradient(
        colors: [
            Color(hex: "#f9ce34"),
            Color(hex: "#ee2a7b"),
            Color(hex: "#6228d7")
        ],
        startPoint: .bottomLeading,
        endPoint: .topTrailing
    )
    
    static let unseenGradient = LinearGradient(
        colors: [
            Color.gray,
            Color.gray.opacity(0.2),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
