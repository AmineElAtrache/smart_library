# 📚 Smart Library

A comprehensive Flutter application for managing personal and institutional libraries with intelligent book scanning, tracking reading progress, and statistics.

## 🎯 Overview

**Smart Library** is a feature-rich mobile application that helps users:
- 📖 Manage their personal or institutional library
- 🔍 Add books via manual entry or ISBN barcode scanning
- 📊 Track reading progress and statistics
- ⭐ Mark favorite books and organize by categories
- 📈 View detailed reading analytics and insights
- 📝 Add notes and quotes from books
- 🌙 Customize with light/dark theme support

## ✨ Key Features

### 📚 Book Management
- **Add Books**: Manually enter book details or scan ISBN barcodes
- **Book Details**: View comprehensive book information including cover, description, author, pages, and reading status
- **Edit Books**: Update book information and reading progress anytime
- **Search & Filter**: Search across the library and filter by categories
- **Reading Status Tracking**: Mark books as "Not Read", "Currently Reading", or "Finished"
- **Progress Tracking**: Monitor page progress for books being read

### 📊 Statistics & Analytics
- **Dashboard**: View monthly reading goals and overall reading statistics
- **Pie Charts**: Visualize reading status distribution (Not Read, Reading, Finished)
- **Category Analytics**: See reading patterns by book category
- **Reading History**: Track your reading history and trends
- **Performance Insights**: Monitor reading goals and achievements

### 💫 Smart Features
- **Favorites**: Mark and manage your favorite books
- **Trending Books**: Discover popular and trending books
- **Personal Notes**: Add custom notes and quotes from books
- **My Quotes**: Collect and save inspiring quotes
- **Search & Suggestions**: Find books via search and get recommendations

### 👤 User Management
- **User Authentication**: Register and login functionality
- **Profile Management**: Update user information and preferences
- **Theme Customization**: Choose between light and dark modes
- **Persistent Data**: All data saved locally with SQLite

## 🚀 Getting Started

### Prerequisites
- **Flutter**: ^3.7.0
- **Dart**: ^3.7.0
- **Android SDK** or **iOS SDK** (for mobile testing)

### Installation

1. **Clone the repository** (if applicable)
   ```bash
   git clone <repository-url>
   cd smart_library
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

4. **Build for specific platform**
   ```bash
   # Android
   flutter build apk
   
   # iOS
   flutter build ios
   
   # Windows/Linux
   flutter build windows
   flutter build linux
   ```

## 📺 Video Demo

Watch the Smart Library in action! Here's where you can add your video demo:

```markdown
![Smart Library Demo](demos/smart_library_demo.mp4)
```

## 🛠️ Technology Stack

| Technology | Purpose |
|-----------|---------|
| **Flutter** | Cross-platform UI framework |
| **Dart** | Programming language |
| **Provider** | State management |
| **SQLite (sqflite)** | Local database for data persistence |
| **Google Books API** | Book search and metadata |
| **Google ML Kit** | Optical Character Recognition (OCR) |
| **Mobile Scanner** | Barcode/QR code scanning |
| **Image Picker** | Select images from device |
| **Image Cropper** | Crop and edit images |
| **FL Chart** | Data visualization and charts |
| **Table Calendar** | Calendar widget for dates |
| **Google Fonts** | Typography customization |
| **Shared Preferences** | User preferences storage |

## 📁 Project Structure

```
smart_library/
├── lib/
│   ├── main.dart                 # Application entry point
│   ├── auth/                     # Authentication logic and database
│   │   ├── auth.dart
│   │   └── database_helper.dart
│   ├── models/                   # Data models
│   │   ├── books_model.dart
│   │   └── user_model.dart
│   ├── pages/                    # UI screens
│   │   ├── home_screen.dart
│   │   ├── add_book_screen.dart
│   │   ├── books_screen.dart
│   │   ├── book_datails_screen.dart
│   │   ├── edit_book_screen.dart
│   │   ├── edit_profile_screen.dart
│   │   ├── favorites_books.dart
│   │   ├── history.dart
│   │   ├── search_result.dart
│   │   ├── trending_books.dart
│   │   ├── MyQuotesScreen.dart
│   │   ├── AddNoteScreen.dart
│   │   ├── setting.dart
│   │   └── layout.dart
│   ├── providers/                # State management
│   │   ├── user_provider.dart
│   │   ├── my_books_provider.dart
│   │   ├── favorites_provider.dart
│   │   ├── history_provider.dart
│   │   └── theme_provider.dart
│   ├── services/                 # API and external services
│   │   └── api_service.dart
│   ├── theme/                    # UI themes and styling
│   │   └── app_themes.dart
│   └── widgets/                  # Reusable UI components
├── assets/                       # Static assets
│   ├── images/
│   └── icons/
├── android/                      # Android-specific code
├── ios/                          # iOS-specific code
├── windows/                      # Windows-specific code
├── linux/                        # Linux-specific code
├── web/                          # Web-specific code
├── test/                         # Unit and widget tests
├── pubspec.yaml                  # Project dependencies
└── README.md                     # This file
```

## 📖 Main Features Deep Dive

### Home Dashboard
- Monthly reading goal progress indicator
- Reading status pie chart (Not Read, Reading, Finished)
- Category-wise reading statistics
- Recently added books carousel
- Quick access to favorite books

### Book Scanner
- Automatic ISBN barcode recognition
- One-tap book addition via barcode scan
- Support for multiple barcode formats
- Image-based OCR text recognition

### Reading Progress
- Track pages read vs. total pages
- Visual progress indicators
- Update reading status in real-time
- Monitor reading velocity

### Favorites & Collections
- Mark favorite books with one tap
- Separate favorites screen for quick access
- Organize books by personal categories
- Filter and sort functionality

### Statistics & Insights
- Reading habits visualization
- Monthly reading trends
- Category distribution analysis
- Performance metrics and goals

## ⚙️ Configuration

### Environment Setup
```bash
# Ensure Flutter is in your PATH
flutter doctor

# Update dependencies
flutter pub upgrade

# Clean build (if needed)
flutter clean
flutter pub get
```

### Custom Configuration
- **Theme**: Edit `lib/theme/app_themes.dart`
- **API Integration**: Update `lib/services/api_service.dart`
- **Database**: Configure in `lib/auth/database_helper.dart`
- **Assets**: Add new images to `assets/` and update `pubspec.yaml`

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## 📦 Building & Deployment

### Android Build
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS Build
```bash
flutter build ios --release
```

### Web Build
```bash
flutter build web --release
```

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🙏 Acknowledgments

- Built with **Flutter** and **Dart**
- Uses **Google Books API** for book data
- Icons and assets from the Flutter community
- Original concept inspired by Book Hive

## 📧 Contact & Support

For questions, issues, or suggestions:
- Open an issue on GitHub
- Contact the development team
- Check the documentation for FAQs

## 🗺️ Roadmap

- [ ] Add cloud synchronization
- [ ] Implement social sharing features
- [ ] Add reading challenges and badges
- [ ] Integrate with Goodreads API
- [ ] Add book recommendations engine
- [ ] Implement audio book support
- [ ] Add book club features
- [ ] Create web version

---

**Made with ❤️ by the Smart Library Team**