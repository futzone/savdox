# Savdox POS 🚀

**Savdox POS** is a modern, cross-platform Point of Sale system built with Flutter. It provides comprehensive functionality for managing products, orders, customers, and suppliers with support for multiple languages.

![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.2+-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-Private-red)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Web-blue)

## ✨ Features

- 📦 **Product Management** - Add, edit, and manage products with categories and barcodes
- 🛒 **Order System** - Create and track orders with detailed history
- 💰 **Billing** - Fast and efficient billing interface with multiple payment methods
- 👥 **Customer Management** - Maintain customer database with purchase history
- 🚚 **Supplier Management** - Track suppliers and deliveries
- 📊 **Reports & Analytics** - Visual charts and comprehensive sales reports
- 🌍 **Multi-language** - Support for Uzbek, Russian, and English
- 🎨 **Themes** - Light and dark mode support
- 💾 **Local Database** - Fast Isar database for offline functionality

## 📚 Documentation

### Complete Documentation (Hujjatlar / Документация)

- 🇺🇿 **[O'zbek tilida](DOCS_UZ.md)** - To'liq hujjatlar
- 🇷🇺 **[На русском](DOCS_RU.md)** - Полная документация
- 🇬🇧 **[English](DOCS_EN.md)** - Complete documentation

### Changelog (O'zgarishlar tarixi / История изменений)

- 🇺🇿 **[O'zbek](CHANGELOG_UZ.md)** - O'zgarishlar tarixi
- 🇷🇺 **[Русский](CHANGELOG_RU.md)** - История изменений
- 🇬🇧 **[English](CHANGELOG_EN.md)** - Changelog

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK 3.9.2 or higher

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd savdox
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Isar database files**
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.9.2+
- **State Management**: Hooks Riverpod
- **Database**: Isar (Local NoSQL)
- **Charts**: FL Chart
- **Internationalization**: Intl
- **UI**: Material Design 3

## 📱 Supported Platforms

- ✅ Android (5.0+)
- ✅ iOS (11.0+)
- ✅ Windows (10+)
- ✅ macOS (10.14+)
- ✅ Linux
- ✅ Web

## 📖 Project Structure

```
savdox/
├── lib/
│   ├── main.dart
│   └── src/
│       ├── core/
│       │   ├── config/
│       │   ├── constants/
│       │   ├── database/
│       │   ├── models/
│       │   ├── providers/
│       │   └── repositories/
│       └── ui/
│           ├── screens/
│           └── widgets/
├── DOCS_UZ.md
├── DOCS_RU.md
├── DOCS_EN.md
├── CHANGELOG_UZ.md
├── CHANGELOG_RU.md
└── CHANGELOG_EN.md
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is private and intended for personal use. Commercial use requires a license.

## 📞 Support

- **Email**: support@savdox.uz
- **Telegram**: @savdox_support
- **Website**: https://savdox.uz

## 🙏 Acknowledgments

Built with ❤️ using Flutter

---

**Savdox POS** - Grow your business! | Biznesingizni rivojlantiring! | Развивайте свой бизнес!
