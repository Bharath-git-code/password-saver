# Password Saver - Flutter App

A secure local password manager for Android built with Flutter.

## Features

✅ **Local Storage** - All passwords stored locally on your device using Hive database
✅ **Encryption** - Passwords encrypted with AES-256 encryption
✅ **Add/Edit/Delete** - Easy CRUD operations for password management
✅ **Search** - Search passwords by place or username
✅ **No Cloud** - Completely offline, no internet required
✅ **Material Design** - Modern UI with Flutter Material 3

## Tech Stack

- **Framework**: Flutter (Dart)
- **Local Database**: Hive (SQLite wrapper)
- **Encryption**: Encrypt (AES-256)
- **State Management**: Provider
- **Platform**: Android

## Project Structure

```
password_saver/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   └── password_entry.dart  # Data model with Hive adapter
│   ├── screens/
│   │   ├── home_screen.dart     # Main password list screen
│   │   └── add_password_screen.dart  # Add/edit password screen
│   ├── services/
│   │   ├── database_service.dart # Database operations
│   │   └── encryption_service.dart # Password encryption/decryption
│   └── providers/
│       └── password_provider.dart # State management
├── pubspec.yaml                  # Dependencies
└── test/
    └── widget_test.dart         # Basic tests
```

## Dependencies

- `hive` & `hive_flutter` - Local database
- `encrypt` & `crypto` - Password encryption
- `provider` - State management
- `build_runner` & `hive_generator` - Code generation for Hive adapters

## Setup Instructions

### Prerequisites

- Flutter SDK installed (done ✓)
- Dart SDK (comes with Flutter)
- Android SDK (for building APK) - needs setup

### Installation

1. Navigate to the project:

   ```bash
   cd password_saver
   ```

2. Get dependencies:

   ```bash
   flutter pub get
   ```

3. Generate Hive adapters:

   ```bash
   flutter pub run build_runner build
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Build APK (Android)

To build a release APK for Android:

```bash
flutter build apk --release
```

The APK will be located at:

```
build/app/outputs/flutter-apk/app-release.apk
```

## Features In Detail

### 1. **Add Password**

- Click the floating action button (+)
- Enter place (Gmail, Facebook, etc.)
- Enter username/email
- Enter password (hidden by default)
- Click "Add Password" to save

### 2. **View Passwords**

- All passwords listed with place name and username
- Click on any entry to view full details
- Shows creation date

### 3. **Edit Password**

- Click menu (three dots) on any password
- Select "Edit"
- Modify any field
- Click "Update Password"

### 4. **Delete Password**

- Click menu (three dots) on any password
- Select "Delete"
- Confirm deletion

### 5. **Search**

- Type in search box
- Searches by place name or username
- Real-time filtering

## Security Notes

⚠️ **Current Implementation**: Uses a fixed encryption key for development. For production:

1. Generate secure random keys
2. Store keys securely in Android Keystore
3. Implement master password/PIN protection
4. Consider biometric authentication

## Building for Android

You need to set up Android SDK:

1. Download Android SDK from: https://developer.android.com/studio
2. Set ANDROID_HOME environment variable
3. Accept Android licenses: `flutter doctor --android-licenses`
4. Run: `flutter build apk --release`

## Running on Device/Emulator

```bash
# List connected devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run on Android emulator
flutter emulators --launch <emulator-id>
flutter run
```

## Testing

Run unit and widget tests:

```bash
flutter test
```

## Future Enhancements

- [ ] Master password/PIN protection
- [ ] Biometric authentication (fingerprint/face)
- [ ] Dark mode
- [ ] Password strength indicator
- [ ] Password generation tool
- [ ] Export/backup feature
- [ ] Multiple password categories
- [ ] Password expiration warnings
- [ ] Sync across devices (with encryption)

## License

This is a personal project. All code is yours to use locally.

## Support

For issues or improvements, you can modify the code directly since it's local development only.

---

**Built with Flutter** ❤️
