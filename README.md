# Secure Notes 🔒

A privacy-first Flutter application designed to store sensitive information securely using local database management and biometric authentication.

## 🚀 Features

- **Biometric Security:** Access is restricted via Fingerprint or Face Recognition using `local_auth`.
- **Persistent Storage:** All notes are stored locally using a SQLite database (`sqflite`).
- **Full CRUD Operations:** Create, Read, Update, and Delete notes seamlessly.
- **Interactive UI:** Supports drag-and-drop reordering with `ReorderableListView` and swipe-to-delete functionality.
- **Multilingual:** Fully localized support for **English** and **Arabic** (RTL support).
- **Date Management:** Integrated date picker for organized note-taking.

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev)
- **Database:** [sqflite](https://pub.dev/packages/sqflite)
- **Authentication:** [local_auth](https://pub.dev/packages/local_auth)
- **Localization:** Flutter Intl & `flutter_localizations`
- **Icons:** Material Design Icons

## 📂 Project Structure

```text
lib/
├── models/          # Note data structures
├── services/        # Database, Auth, and Logic
├── screens/         # UI Pages (Auth, Home, Add/Edit)
├── widgets/         # Reusable UI components
├── l10n/            # English and Arabic translation files
└── main.dart        # App entry point
```

## ⚙️ Installation & Setup
 * Clone the repository:
 ```
 git clone [https://github.com/walid-zouguagh/secure_notes.git](https://github.com/walid-zouguagh/secure_notes.git)
 ```
 * Install dependencies:
 ```
 flutter pub get
 ```
 * Platform Setup:

    * Android: Ensure USE_BIOMETRIC permission is in AndroidManifest.xml.

    * iOS: Ensure NSFaceIDUsageDescription is in Info.plist.
* Run the app:
    ```
    flutter run
    or
    TMPDIR=~/flutter_tmp flutter run 
    ```
