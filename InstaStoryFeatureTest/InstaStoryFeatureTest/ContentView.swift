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
        LazyHStack {
            ForEach(Array(viewModel.userStories.enumerated()), id: \.element.id) { index, story in
                UserStoryCell(userStory: story, currentUser: MockedUsers.currentUser)
                    .onTapGesture {
                        viewModel.presentExplorer = true
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
        .fullScreenCover(isPresented: $viewModel.presentExplorer) {
            Text("Story selected")
        }
    }
}
}

#Preview {
    ContentView()
}
