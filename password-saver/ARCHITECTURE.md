# Architecture & Code Overview

## App Architecture

```
┌─────────────────────────────────────┐
│     main.dart (App Entry)           │
│  - Initializes database             │
│  - Sets up routing                  │
│  - Configures Provider              │
└──────────────┬──────────────────────┘
               │
        ┌──────┴────────┐
        ▼               ▼
    HomeScreen    AddPasswordScreen
    (View)        (View)
        │               │
        └───────┬───────┘
                │
        ┌───────▼────────┐
        │ PasswordProvider│ (State Management)
        │ - passwords    │
        │ - search()     │
        │ - add/edit/del │
        └───────┬────────┘
                │
        ┌───────▼────────┐
        │DatabaseService │ (Business Logic)
        │ - getAllPasswords()
        │ - addPassword()
        │ - updatePassword()
        │ - deletePassword()
        │ - searchPasswords()
        └───────┬────────┘
                │
        ┌───────┴────────────┬──────────────┐
        ▼                    ▼              ▼
   EncryptionService    Hive Box      PasswordEntry
   (Encryption)        (Database)      (Model)
   - encryptPassword()  - passwords     - place
   - decryptPassword()                  - username
                                        - password
                                        - createdAt
```

## Data Flow

### Adding a Password

```
HomeScreen (+Button)
    ↓
AddPasswordScreen (form)
    ↓
PasswordProvider.addPassword()
    ↓
DatabaseService.addPassword()
    ↓
EncryptionService.encryptPassword()
    ↓
Hive Box.add()
    ↓
HomeScreen (refreshes list)
```

### Viewing Passwords

```
DatabaseService.getAllPasswords()
    ↓
For each password:
    ├─ EncryptionService.decryptPassword()
    └─ Display in ListView
```

### Searching

```
Search TextField
    ↓ (onChange)
PasswordProvider.searchPasswords()
    ↓
DatabaseService.searchPasswords()
    ↓
Filter by place/username
    ↓
Update filtered list
```

## Key Classes & Their Responsibilities

### PasswordEntry (Model)

```dart
@HiveType
class PasswordEntry extends HiveObject {
  String place;           // e.g., "Gmail", "Facebook"
  String username;        // e.g., "user@example.com"
  String password;        // encrypted
  DateTime createdAt;     // timestamp
}
```

### EncryptionService

Handles password encryption/decryption:

- Uses fixed AES key (development)
- IV (initialization vector) for randomness
- Base64 encoding for storage

### DatabaseService

CRUD operations on Hive database:

- Init: Open Hive box and register adapters
- Create: `addPassword()` (encrypts then stores)
- Read: `getAllPasswords()`, `getPassword(index)`
- Update: `updatePassword(index, ...)`
- Delete: `deletePassword(index)`
- Search: `searchPasswords(query)`

### PasswordProvider (State)

Business logic & state management:

- Maintains password list in memory
- Handles search state
- Triggers database operations
- Notifies UI of changes

### HomeScreen (UI)

Main password list view:

- Displays all passwords
- Search textfield
- ListView of password cards
- FAB for adding new
- Popup menu for edit/delete

### AddPasswordScreen (UI)

Form for adding/editing passwords:

- Place, username, password inputs
- Show/hide password toggle
- Validation before save
- Different title for add vs edit

## State Management Flow

```
┌─────────────────────────────────────┐
│   PasswordProvider (ChangeNotifier)  │
├─────────────────────────────────────┤
│ State:                              │
│  - _passwords: List<PasswordEntry>  │
│  - _filteredPasswords: List<...>   │
│  - _searchQuery: String             │
├─────────────────────────────────────┤
│ Methods:                            │
│  - addPassword()                    │
│  - updatePassword()                 │
│  - deletePassword()                 │
│  - searchPasswords()                │
│  - clearSearch()                    │
│  - _loadPasswords()                 │
├─────────────────────────────────────┤
│ Listeners:                          │
│  - HomeScreen                       │
│  - AddPasswordScreen                │
└─────────────────────────────────────┘
```

When state changes → `notifyListeners()` → UI rebuilds

## Database Schema

Hive stores documents (no schema):

```
Box Name: 'password_box'

Each entry:
{
  key: 0,
  value: PasswordEntry(
    place: "Gmail",
    username: "user@example.com",
    password: "encrypted_base64_string",
    createdAt: 2024-01-28 10:30:00,
  )
}
```

## Security Layers

1. **Encryption** - AES-256 for password data
2. **Local Storage** - Hive persists to device
3. **No Network** - Completely offline
4. **In-Memory** - Decrypted only when needed

To enhance:

- Master password for app access
- Biometric authentication
- Secure key storage in Android Keystore
- Auto-lock after timeout

## File Locations

```
password_saver/
├── lib/
│   ├── main.dart                  (70 lines)
│   ├── models/
│   │   ├── password_entry.dart    (27 lines)
│   │   └── password_entry.g.dart  (auto-generated)
│   ├── services/
│   │   ├── database_service.dart  (75 lines)
│   │   └── encryption_service.dart (25 lines)
│   ├── screens/
│   │   ├── home_screen.dart       (220 lines)
│   │   └── add_password_screen.dart (140 lines)
│   └── providers/
│       └── password_provider.dart  (50 lines)
├── test/
│   └── widget_test.dart           (21 lines)
├── pubspec.yaml                   (101 lines)
└── README.md
```

## Build & Dependencies

### pubspec.yaml

```yaml
dependencies:
  flutter: sdk: flutter
  cupertino_icons: ^1.0.8
  hive: ^2.2.3                    # Database
  hive_flutter: ^1.1.0            # Flutter bindings
  encrypt: ^5.0.1                 # Encryption
  crypto: ^3.0.3                  # Crypto utils
  provider: ^6.1.0                # State management

dev_dependencies:
  flutter_test: sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.0            # Code generation
  hive_generator: ^2.0.0          # Hive adapters
```

## Performance Considerations

- **List Performance**: Uses ListView.builder (lazy loading)
- **Search**: O(n) filtering, good for <1000 entries
- **Encryption**: Fast for typical password sizes
- **Memory**: Decrypts on-demand, not pre-loaded

For optimization:

- Implement pagination for 1000+ passwords
- Cache decrypted passwords in memory
- Implement background sync if needed

## Testing

Basic widget test included:

```dart
testWidgets('Password Saver smoke test', ...)
```

To add more tests:

- Unit tests for services
- Widget tests for screens
- Integration tests for flows

Run with: `flutter test`

---

This architecture ensures clean separation of concerns with a clear data flow from UI → State → Logic → Database.
