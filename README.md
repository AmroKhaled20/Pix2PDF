# 📄 Image to PDF Converter App

A robust, fully offline Flutter application designed to convert camera captures and gallery photos into organized, high-quality PDF files. Built following production-ready software engineering standards.

---

## ✨ Key Features

- **Capture & Pick:** Take photos directly via the device camera or select multiple images from the gallery.
- **Instant Conversion:** Convert single or multiple images into a professional PDF file instantly.
- **PDF Management:** Search, view, share, and delete saved PDF files seamlessly.
- **Multi-Selection Mode:** Built-in batch selection UI for bulk deleting files with a dynamic app bar.
- **PDF Editing:** Update existing PDF documents by adding or removing pages.
- **100% Offline:** Operates entirely offline with secure local file storage and image caching.

---

## 🏗️ Architecture & Tech Stack

This project is structured using **Clean Architecture** principles and **MVVM** pattern in the presentation layer to ensure high scalability, testability, and a clean separation of concerns.

- **Framework:** Flutter (Dart)
- **State Management:** `flutter_bloc` (Cubit)
- **Architecture:** Clean Architecture (Presentation, Domain, Data layers)
- **Navigation:** `go_router`
- **Dependency Injection:** `get_it`
- **Local Persistence & Storage:** Device internal file storage and caching.

---

## 🚀 Getting Started

To run this project locally, make sure you have [Flutter installed](https://docs.flutter.dev/get-started/install).

### 1. Clone the repository

```bash
git clone https://github.com/AmroKhaled20/Scanify-App.git
```

### 2. Navigate to the project directory

```bash
cd Scanify-App
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the app

```bash
flutter run
```
