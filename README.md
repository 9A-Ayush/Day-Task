# Day-Task

A modern task management application built with Flutter and Supabase.

## Features

- ✅ User Authentication (Email/Password & Google Sign-In)
- ✅ Persistent Login Sessions
- ✅ Create, Read, Update, Delete Tasks
- ✅ Subtask Management
- ✅ Team Member Assignment
- ✅ Real-time Task Updates
- ✅ Progress Tracking
- ✅ User Profile Management
- ✅ Avatar Selection
- ✅ Dark Theme UI

## Tech Stack

- **Frontend**: Flutter
- **Backend**: Supabase
- **State Management**: Provider
- **Authentication**: Supabase Auth + Google Sign-In

## Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Supabase Account
- Android Studio / VS Code

### Installation

1. Clone the repository
```bash
git clone https://github.com/9A-Ayush/Day-Task.git
cd Day-Task
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Supabase
- Update `lib/config/supabase_config.dart` with your Supabase credentials
- Run the SQL migration from `supabase_migration.sql`

4. Run the app
```bash
flutter run
```

## Project Structure

```
lib/
├── config/          # Configuration files
├── models/          # Data models
├── providers/       # State management
├── screens/         # UI screens
├── services/        # API services
├── theme/           # App theming
├── widgets/         # Reusable widgets
└── main.dart        # Entry point
```

## Documentation

- [Production Ready Guide](PRODUCTION_READY_GUIDE.md)
- [Supabase Setup](SUPABASE_SETUP.md)
- [Profile Feature](PROFILE_FEATURE.md)

## License

This project is licensed under the MIT License.
