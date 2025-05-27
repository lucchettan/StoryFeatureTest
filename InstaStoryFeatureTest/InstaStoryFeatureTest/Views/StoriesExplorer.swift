//
//  StoriesExplorer.swift
//  InstaStoryFeatureTest
//
//  Created by Nicolas Lucchetta on 27/05/2025.
//

import SwiftUI

struct StoriesExplorer: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var userStories: [UserStory] = []
    @State var storyIndex: Int = 0
    @State var storyItemIndex: Int = 0
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            if let imageURL = URL(string: userStories[storyIndex].items[storyItemIndex].imageURL) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .aspectRatio(contentMode: .fill)
                            .onAppear {
                                // Trigger a progress
                            }
                    case .failure(_):
                        VStack {
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                            Text("Failed to load image")
                        }
                        .onAppear {
                            // Trigger a progress
                        }
                    case .empty:
                        ZStack {
                            Color.black
                            ProgressView()
                                .tint(.white)
                        }
                        .onAppear {
                            // Navigate to next
                        }
                    @unknown default:
                        Color.black
                    }
                }
            }
            
            // UI Overlays
            VStack {
                // Progress Indicators
                HStack {
                    Capsule()
                    Capsule()
                    Capsule()
                }
                
                HStack {
                    if let avatarImage = userStories[storyIndex].avatarImage {
                        Image(uiImage: avatarImage)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        onDismiss()
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.white)
                    }
                }
                .padding()
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: { /* Like/Dislike */}) {
                        Image(systemName: "heart") // heart.fill when like white/red if liked/disliked
                    }
                }
            }
            .padding(.vertical, 40)
            
            // Gesture handlers
            // - onTap left/right side go next/previous item(if available) or story if next/previous item is unavailable
            // - on swipe left/right go next/previous story
            // - on swipe down dismiss+onDismiss
            Color.clear
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    
                }
        }
    }
}
