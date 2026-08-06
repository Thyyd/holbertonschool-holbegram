# Holbegram

Une application mobile développée avec **Flutter**, reproduisant les fonctionnalités principales d'Instagram.

## 🛠️ Stack Technique

- **Framework :** [Flutter](https://flutter.dev/) (Dart)
- **Backend / Authentification / Base de données :** [Firebase](https://firebase.google.com/)
  - Firebase Authentication (Email/Mot de passe)
  - Cloud Firestore
- **Stockage des médias :** [Cloudinary](https://cloudinary.com/)
- **IDE :** Visual Studio Code (avec les extensions Flutter & Dart)

## ⚙️ Mise en place du projet

### 1. Prérequis

- [SDK Flutter](https://docs.flutter.dev/get-started/install) installé et ajouté au PATH
- [Android Studio](https://developer.android.com/studio) (avec le SDK Android & un émulateur, ou un appareil physique)
- [Visual Studio Code](https://code.visualstudio.com/) avec l'extension Flutter
- Un compte [Firebase](https://firebase.google.com/)
- Un compte [Cloudinary](https://cloudinary.com/)

Vérifie ton installation à tout moment avec :

```bash
flutter doctor
```

### 2. Cloner le dépôt & installer les dépendances

```bash
git clone <repository_url>
cd holbegram
flutter pub get
```

### 3. Configuration Firebase

Ce projet utilise Firebase pour l'authentification et le stockage des données. Le projet Firebase `holbegram` est configuré avec :

- **Nom du package Android :** `com.example.holbegram`
- **Fournisseur d'authentification :** Email/Mot de passe

Pour connecter ton propre projet Firebase :

1. Crée un projet sur la [Firebase Console](https://console.firebase.google.com/).
2. Enregistre une app Android avec le nom de package `com.example.holbegram` (doit correspondre à `android/app/build.gradle.kts`).
3. Télécharge le fichier `google-services.json` généré et place-le dans `android/app/`.
4. Active la connexion **Email/Mot de passe** dans **Authentication > Sign-in method**.

> ⚠️ Le support iOS nécessite macOS et Xcode, et n'est pas couvert dans cette configuration (développement effectué sur Windows).

### 4. Lancer l'application

```bash
flutter run
```

Sélectionne un appareil/émulateur Android connecté, ou Chrome pour un aperçu rapide sur le web.

## 📂 Structure du projet

```
holbegram/
├── android/          # Configuration spécifique à Android (Firebase, Gradle)
├── ios/              # Configuration spécifique à iOS (non utilisée dans cette configuration)
├── lib/              # Code source Dart principal
├── test/             # Tests unitaires et de widgets
└── pubspec.yaml       # Dépendances du projet
```

## ✍️ Auteur

- **Thyyd** - [GitHub](https://github.com/thyyd)

## 📄 Licence

Ce projet est développé à des fins éducatives.


-----------------------------------------------------------------------------------------------------------------------------------

# Holbegram

A mobile application built with **Flutter**, replicating core features of Instagram.

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **Backend / Authentication / Database:** [Firebase](https://firebase.google.com/)
  - Firebase Authentication (Email/Password)
  - Cloud Firestore
- **Media Storage:** [Cloudinary](https://cloudinary.com/)
- **IDE:** Visual Studio Code (with the Flutter & Dart extensions)

## ⚙️ Project Setup

### 1. Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and added to your PATH
- [Android Studio](https://developer.android.com/studio) (with Android SDK & an emulator, or a physical device)
- [Visual Studio Code](https://code.visualstudio.com/) with the Flutter extension
- A [Firebase](https://firebase.google.com/) account
- A [Cloudinary](https://cloudinary.com/) account

Verify your setup at any time with:

```bash
flutter doctor
```

### 2. Clone & install dependencies

```bash
git clone <repository_url>
cd holbegram
flutter pub get
```

### 3. Firebase configuration

This project uses Firebase for authentication and data storage. The Firebase project `holbegram` is configured with:

- **Android package name:** `com.example.holbegram`
- **Authentication provider:** Email/Password

To connect your own Firebase project:

1. Create a project on the [Firebase Console](https://console.firebase.google.com/).
2. Register an Android app with the package name `com.example.holbegram` (must match `android/app/build.gradle.kts`).
3. Download the generated `google-services.json` file and place it in `android/app/`.
4. Enable **Email/Password** sign-in under **Authentication > Sign-in method**.

> ⚠️ iOS support requires macOS and Xcode, and is not covered in this setup (developed on Windows).

### 4. Run the app

```bash
flutter run
```

Select a connected Android device/emulator, or Chrome for a quick web preview.

## 📂 Project Structure

```
holbegram/
├── android/          # Android-specific configuration (Firebase, Gradle)
├── ios/              # iOS-specific configuration (not used in this setup)
├── lib/              # Main Dart source code
├── test/             # Unit and widget tests
└── pubspec.yaml       # Project dependencies
```

## ✍️ Author

- **Thyyd** - [GitHub](https://github.com/thyyd)

## 📄 License

This project is developed for educational purposes.
