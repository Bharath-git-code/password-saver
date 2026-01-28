# Quick Start Guide

## What You Have

Your Flutter Password Manager app is ready to use! The complete app is in:

```
C:\Users\z004nrhb\OneDrive - Siemens AG\D_drive_files\Sourcecode\personal_project\password-saver\password_saver
```

## What's Included

✅ Complete Flutter app structure
✅ Local SQLite database (Hive)
✅ AES-256 password encryption
✅ Beautiful Material Design UI
✅ Search functionality
✅ Add/Edit/Delete operations
✅ No internet required - everything is local

## Running the App

### Option 1: On Android Emulator (Easiest for testing)

1. Install Android SDK and set it up
2. Create/launch an Android emulator
3. Run in terminal:
   ```bash
   cd "password_saver"
   flutter run
   ```

### Option 2: On Physical Android Device

1. Enable USB Debugging on your phone
2. Connect via USB
3. Run:
   ```bash
   flutter run
   ```

### Option 3: Build APK (For installation)

1. Set up Android SDK properly
2. Run:
   ```bash
   flutter build apk --release
   ```
3. Transfer `build/app/outputs/flutter-apk/app-release.apk` to your phone
4. Install it

## App Features

### Home Screen

- List of all saved passwords
- Search box to find passwords
- Click to view full details
- Long-press for edit/delete options
- Floating action button (+) to add new

### Add/Edit Password Screen

- Enter place (e.g., Gmail, Facebook, Twitter)
- Enter username/email
- Enter password (hidden by default)
- Shows/hides password toggle
- Save or update button

### Password Details View

- View full password (click on entry)
- Shows creation date
- Edit or delete options

## Key Technologies

| Technology        | Purpose                         |
| ----------------- | ------------------------------- |
| Flutter           | Cross-platform mobile framework |
| Dart              | Programming language            |
| Hive              | Local NoSQL database            |
| Encrypt           | AES-256 password encryption     |
| Provider          | State management                |
| Material Design 3 | UI framework                    |

## Project Files

```
lib/
├── main.dart                    → App start & routing
├── models/password_entry.dart   → Password data class
├── screens/
│   ├── home_screen.dart        → Main list view
│   └── add_password_screen.dart → Add/edit form
├── services/
│   ├── database_service.dart   → Database operations
│   └── encryption_service.dart → Password encryption/decryption
└── providers/
    └── password_provider.dart   → State management & business logic
```

## Useful Commands

```bash
# Check Flutter installation
flutter doctor

# Get dependencies
flutter pub get

# Generate code (for Hive adapters)
flutter pub run build_runner build

# Run app
flutter run

# Build APK
flutter build apk --release

# Build debug APK
flutter build apk --debug

# Clean build
flutter clean

# Run tests
flutter test
```

## Database Location

Your passwords are stored in:

```
Android: /data/data/com.example.password_saver/
iOS: App Documents folder
```

The database file is `password_box.hive` (encrypted)

## Security

✅ Passwords are encrypted with AES-256
✅ Database stored locally on device
✅ No cloud/internet sync
✅ No analytics or tracking

### For Production Use, Add:

- Master password
- Biometric authentication (fingerprint)
- Secure key generation
- Backup & restore feature

## Troubleshooting

**Issue: "flutter: The term is not recognized"**

- Add Flutter to PATH environment variable
- Restart terminal after setting PATH

**Issue: "No Android SDK found"**

- Download Android SDK
- Set ANDROID_HOME environment variable
- Run `flutter doctor --android-licenses`

**Issue: "Build fails"**

- Run `flutter clean`
- Run `flutter pub get`
- Run `flutter pub run build_runner build`
- Try again

**Issue: "App crashes on startup"**

- Check logs: `flutter logs`
- Ensure database initialized properly
- Try `flutter clean` and reinstall

## Next Steps

1. **Test the app** on emulator or device
2. **Add some passwords** to test functionality
3. **Check the code** and understand how it works
4. **Customize it** - colors, app name, features, etc.
5. **Deploy** as APK to your device

## Customization Ideas

- Change app colors (in Material theme)
- Add password strength indicator
- Add password generation tool
- Add dark mode
- Add export/backup feature
- Add categories for passwords
- Add PIN/biometric lock
- Add password expiration warnings

## Getting Help

- Flutter docs: https://flutter.dev/docs
- Hive docs: https://docs.hivedb.dev/
- Stack Overflow: Tag `flutter`

---

**Your app is ready to use!** 🚀
