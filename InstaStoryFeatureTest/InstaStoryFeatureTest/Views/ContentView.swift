//
//  ContentView.swift
//  InstaStoryFeatureTest
//
//  Created by Nicolas Lucchetta on 27/05/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext

    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal) {
                    if viewModel.isLoadingAvatarsDone {
                        storyRow
                    } else {
                        ProgressView("")
                            .frame(width: 90, height: 90)
                            .padding(.horizontal, 5)
                    }
                    
                }
                .frame(height: 100)
                .scrollIndicators(.hidden)
                
                Spacer()
            }
        }
        .task {
            await viewModel.fetchStoriesAndPreloadAvatarImages(context: modelContext)
        }
        .navigationTitle("For you")
    }
    
    var storyRow: some View {
        ScrollViewReader { proxy in
            LazyHStack(spacing: 12) {
                ForEach(Array(viewModel.userStories.enumerated()), id: \.element.id) { index, story in
                    UserStoryCell(userStory: story, currentUser: MockedUsers.currentUser)
                        .task {
                            if index == viewModel.userStories.count - 1 {
                                await viewModel.addMockedContent(from: modelContext, count: 5)

                            }
                        }
                        .onTapGesture {
                            viewModel.selectedIndex = index
                        }
                }
                
                // Loading indicator at the end
                if viewModel.isLoadingMore {
                    ProgressView()
                        .frame(width: 60, height: 60)
                        .padding(.horizontal, 15)
                }
            }
            .padding(.leading)
        }
        .fullScreenCover(item: $viewModel.selectedIndex) { index in
            StoriesExplorer(
                userStories: viewModel.userStories,
                initialStoryIndex: index,
                onDismiss: {
                    viewModel.selectedIndex = nil
                    // Refresh or update the UI state here if needed
                    Task {
                        await viewModel.fetchStoriesAndPreloadAvatarImages(context: modelContext)
                    }
                }
            )
        }
    }
}

// Workaround to use an optionnal int as item in the fullScreenCover as it requires the item to be Identifiable.
extension Int: @retroactive Identifiable {
    public var id: Int { self }
}

#Preview {
    ContentView()
}
