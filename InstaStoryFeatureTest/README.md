# Insta Story Feature

## Overview
This project implements an Instagram-like story feature using SwiftUI, following the MVVM and Clean Architecture principles. The main goal is to fetch stories and their content, allowing users to like and view content persistently.

## Architectural Decisions

### MVVM Pattern
- **Model-View-ViewModel (MVVM)**: This pattern is used to separate the UI from the business logic. The `ViewModel` handles data fetching and business logic, while the `View` is responsible for displaying the UI.

### Clean Architecture
- **Separation of Concerns**: The architecture separates the app into layers, each with a distinct responsibility. This makes the app more maintainable and testable.

### Persistence
- **SwiftData**: Used for data persistence, allowing the app to save and retrieve user interactions, such as seen and liked stories, even after the app is closed.
- **ModelContext**: Used to manage data operations and ensure changes are saved to the persistent store.

### User Interaction
- **Story Viewing**: Users can view stories in a full-screen explorer. Progress indicators and gestures are used to navigate through story items.
- **Liking and Seeing Content**: Users can like story items, and the app tracks which items have been seen, updating the UI accordingly.

### UI Design
- **SwiftUI**: Utilized for building a modern, responsive UI that adapts to different screen sizes and orientations.
- **Animations and Gestures**: Used to enhance user experience, providing smooth transitions and interactions.

## Conclusion
The Insta Story feature is designed to be scalable and maintainable, leveraging modern SwiftUI and architectural patterns to provide a seamless user experience. 

## HOWEVER
- Sadly taken up by some unexpected difficulties along the way happend and I have some hard feeling about some uncompletion of the tasks:
- I have missed the .id() on the async image wich prevented the app to triggers the progress when displaying a story item and I have been looking for more than 30 with my dear brain, google, and ai's before realizing my mistake
- Persistence is not functionning, I might be able to sort that through the day and submit a fix but as of now after 4 Hours on the task it is not storing properly when we see and like items even though the structure and interaction are properly in place for that.
- Testing have been left behind I have to admit I have focused on realizing a smooth and satisfaying UI first before running the tests as no network or complicated calls are in place it did not feel mandatory to build a strong platform

## Happy me
I am pretty happy about the simplicity of the structures and logics in place, especially for the progress bar to let the user know where he's at in a story. I expect your codebase to be way more interesting than mine but here's a glimpse of the style I usually work in a fast paced challenge, keeping things readable, debuggable and strong while not overcomplexified.

** Thank you for your time and the opportunity to submit this challenge to you, collaborating on a such big scaled project would be a strong achievment in my carreer and I am ready for this kind of challenge to bring the real people the best platform to express themself while not showing off and creating unrealistic expectations into their audience **
