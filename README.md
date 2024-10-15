# JGames

**Note:** The `J` suffix denotes that this is an in-house solution tailored for our specific needs.

### Features
- Users can see a list of games with brief information (i.e., name, release year, and thumbnail).
- Users can scroll infinitely.
- Users can pull to refresh the content.
- Tapping on a game displays its full information (i.e., cover, name, release date, platforms, genres, summary, ratings, and screenshots).
- Users can navigate offline with cached content.

### Setup

- **Xcode Version:** 13.4.1 (Note: My personal MacBook does not support later versions.)
- **Minimum iOS Version:** 15.5 for the main target and packages.
- **Device Support:** Supports iPhone only, in portrait mode, as a landscape view is impractical for this use case.

### Technology Stack

- **UI Implementation:** Built using `SwiftUI` for ease of UI development.
- **ViewModel Architecture:** Implemented with `Combine` to enable reactive binding between views and enhance responsiveness.
- **Offline Mode:** Implemented with `CoreData` to save and handled cached content.
- **Tests:** Each view model, view data and repositories are tested with diverse scenarios to ensure reliability and performance.
- **Memory Management:** The application is free of memory leaks and retain cycles, ensuring that all entities are properly deallocated.

### Frameworks

To ensure modularity, separation of concerns, and improved build times, the project is structured as follows:

- **JFoundation:** Contains shareable utilities and extensions.
- **JUI:** Implements the design system and UI components.
- **JData:** Manages network integration and data handling.
- **App:** The main bundle housing primary features:
  - **Games > List:** Displays the list of games.
  - **Games > Detail :** Displays the full information about a game.

**Package Management:** Utilizes `Swift Package Manager` for managing local frameworks, providing a straightforward integration process.

**Dependency Management:** There are no circular dependencies in the project structure.

**External library:** It imports `Kingfisher`, which handles image loading and caching logic out of the box.