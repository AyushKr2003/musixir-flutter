# Musixir - Music Streaming App

Musixir is a modern, feature-rich music streaming application built with Flutter. Experience your favorite music with a beautiful dark-themed interface and smooth animations.

## Features

- 🎵 Music Streaming
- 🔍 Smart Search Functionality
- 🎨 Modern Dark Theme Interface
- 🔐 User Authentication
- 📱 Responsive Design
- 🎶 Background Audio Playback

## Tech Stack

- **Framework**: Flutter
- **State Management**: Riverpod
- **Audio Engine**: just_audio
- **Background Playback**: just_audio_background
- **Authentication**: Custom implementation
- **Design**: Material Design with custom theme

## Screenshots

<div style="display: flex; flex-wrap: wrap; gap: 10px;">

| Splash Screen | Login Screen | Home Screen |
|--------------|--------------|-------------|
| <img src="assets\screenshots\splash_screen.png" width="200"/> | <img src="assets\screenshots\login_screen.png" width="200"/> | <img src="assets\screenshots\home_screen.png" width="200"/> |

| Search Screen | Player Screen | Library Screen |
|--------------|---------------|----------------|
| <img src="assets\screenshots\search_screen.png" width="200"/> | <img src="assets\screenshots\player_page.png" width="200"/> | <img src="assets\screenshots\library_page.png" width="200"/> |

</div>

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK
- Android Studio / VS Code
- Android SDK for Android deployment
- Xcode for iOS deployment (Mac only)

### Installation

1. Clone the repository:
```bash
git clone [your-repository-url]
```

2. Navigate to the project directory:
```bash
cd client
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and configurations
│   ├── failure/            # Error handling and failures
│   ├── model/              # Core data models
│   ├── provider/           # Global providers
│   ├── theme/              # App theme configuration
│   ├── widgets/            # Reusable widgets
│   └── utils.dart          # Utility functions
├── features/
│   ├── auth/               # Authentication feature
│   │   ├── repositories/   # Auth repositories
│   │   ├── view/           # Auth UI components
│   │   └── viewmodel/      # Auth business logic
│   └── home/               # Home feature
│       ├── model/          # Home data models
│       ├── repository/     # Home repositories
│       ├── view/           # Home UI components
│       └── viewmodel/      # Home business logic
└── main.dart               # App entry point
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the [MIT License](LICENSE) - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Riverpod for state management
- just_audio for audio capabilities
- All contributors and supporters

---

Made with ❤️ using Flutter
