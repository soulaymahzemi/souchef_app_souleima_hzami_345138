# SouChef 👨‍🍳

SouChef is a comprehensive recipe and cooking application built with Flutter. It allows users to browse recipes, follow chefs, view cooking reels, and manage their profile. The app is designed with a modern UI, responsiveness, and robust architecture.

## 🚀 Features

- **Authentication**: Secure Sign Up and Login using Firebase Auth.
- **Recipe Discovery**: Browse a variety of recipes with detailed information (time, calories, rating).
- **Chefs**: Explore a list of chefs and follow your favorites.
- **Reels**: Watch engaging cooking videos and intros.
- **Profile Management**: Update user profile, including profile picture.
- **Favorites**: Save and manage your favorite recipes.
- **Responsive Design**: Optimized for different screen sizes using `flutter_screenutil`.
- **Theming**: Consistent light theme with custom color palettes.

## 📸 Screenshots

| Login | Home |
|:---:|:---:|
| ![Login Screen](assets/screenshots/login_screen.png) | ![Home Screen](assets/screenshots/home_screen.png) |
| **Recipe Detail** | **Profile** |
| ![Recipe Detail](assets/screenshots/recipe_detail.png) | ![Profile Screen](assets/screenshots/profile_screen.png) |

## 🏗️ Architecture

This project follows the **MVVM (Model-View-ViewModel)** architectural pattern to ensure separation of concerns and maintainability.

- **Model**: Represents the data structures (e.g., `Recipe`, `Chef`).
- **View**: The UI layer that displays data and captures user interactions (e.g., `HomeView`, `LoginView`).
- **ViewModel**: Acts as a bridge between Model and View, handling business logic and state management using `Provider`.

### State Management
The application uses **Provider** for state management, satisfying the MVVM pattern. ViewModels extend `ChangeNotifier` to notify the UI of state changes.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Language**: [Dart](https://dart.dev/)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Backend/Auth**: [Firebase Core](https://pub.dev/packages/firebase_core) & [Auth](https://pub.dev/packages/firebase_auth)
- **Networking**: [http](https://pub.dev/packages/http)
- **UI Utilities**:
  - [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) (Responsiveness)
  - [shimmer](https://pub.dev/packages/shimmer) (Loading effects)
  - [google_fonts](https://pub.dev/packages/google_fonts) (Typography)
- **Media**:
  - [video_player](https://pub.dev/packages/video_player)
  - [image_picker](https://pub.dev/packages/image_picker)
- **Storage**: [shared_preferences](https://pub.dev/packages/shared_preferences)

## 📂 Folder Structure

The project is structured into `core` and `features` to keep the codebase modular.

```
lib/
├── core/                  # Core utilities and shared components
│   ├── them/              # Theme definitions (colors, text styles)
│   ├── utils/             # Helper classes (constants, formatters)
│   └── widgets/           # reusable widgets (Buttons, TextFields)
│
├── features/              # Feature-based organization
│   ├── authentification/  # Login, Sign Up
│   │   ├── model/
│   │   ├── view/
│   │   └── viewmodel/
│   ├── home/              # Home screen, Recipes, Chefs
│   ├── intro/             # Onboarding, Splash, Welcome
│   └── profile/           # User Profile
│
├── firebase_options.dart  # Firebase configuration
└── main.dart              # Entry point & Provider setup
```

## 🏁 Getting Started

### Prerequisites
- Flutter SDK installed (Version ^3.5.4)
- Dart SDK
- Android Studio / VS Code

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/souchef.git
   ```

2. **Navigate to the project directory:**
   ```bash
   cd esame
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the application:**
   ```bash
   flutter run
   ```

## 📄 License

This project is for educational purposes.
