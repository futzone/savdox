# Savdox POS - Documentation (English)

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [System Requirements](#system-requirements)
- [Features](#features)
- [User Guide](#user-guide)
- [Database](#database)
- [Settings](#settings)
- [Technical Support](#technical-support)

## Introduction

**Savdox POS** is a modern Point of Sale system developed using Flutter. The application provides complete functionality for managing products, orders, customers, and suppliers.

### Main Purpose
Savdox POS is designed to provide simple, fast, and efficient sales processes for small and medium-sized businesses.

## Installation

### 1. Install Flutter SDK
```bash
# Download and install Flutter SDK
# https://docs.flutter.dev/get-started/install
```

### 2. Clone the project
```bash
git clone <repository-url>
cd savdox
```

### 3. Install dependencies
```bash
flutter pub get
```

### 4. Build Isar database
```bash
flutter pub run build_runner build
```

### 5. Run the application
```bash
flutter run
```

## System Requirements

### Minimum Requirements
- **Flutter SDK**: 3.9.2 or higher
- **Dart SDK**: 3.9.2 or higher
- **Memory**: 4 GB RAM (recommended: 8 GB)
- **Disk Space**: 500 MB free space

### Supported Platforms
- ✅ Android (5.0 and above)
- ✅ iOS (11.0 and above)
- ✅ Windows (10 and above)
- ✅ macOS (10.14 and above)
- ✅ Linux
- ✅ Web

## Features

### 📦 Product Management
- Add, edit, and delete products
- Product categories
- Prices and discounts
- Inventory control
- Barcode support

### 🛒 Order System
- Create new orders
- Track order status
- View order history
- Print receipts

### 💰 Billing
- Fast and convenient billing interface
- Multiple payment methods
- Discounts and promotions
- Create and print receipts

### 👥 Customer Management
- Customer database
- Customer history
- Loyalty program
- Contact information

### 🚚 Suppliers
- Supplier list
- Contact information
- Delivery history
- Accounting

### 📊 Reports and Analytics
- Daily/weekly/monthly sales reports
- Charts and graphs (using fl_chart)
- Best-selling products
- Revenue analysis

### ⚙️ Settings
- Language selection (Uzbek, Russian, English)
- Theme (Light/Dark)
- Currency settings
- Receipt settings
- User profile

## User Guide

### First Launch

1. **Open the application**
   - The main screen appears when opening

2. **Configure settings**
   - Go to the settings section
   - Select language
   - Configure currency
   - Enter company information

### Adding a Product

1. **Go to the products section**
   - Click the "Products" button in the main menu

2. **Add a new product**
   - Click the "+" button
   - Enter product information:
     - Name
     - Price
     - Category
     - Quantity
     - Barcode (optional)
   - Click the "Save" button

### Creating an Order

1. **Go to the billing screen**
   - Click the "Billing" button in the main menu

2. **Select products**
   - Find products through search
   - Or scan barcode
   - Enter quantity

3. **Complete payment**
   - Select payment method
   - Enter amount
   - Click the "Pay" button

4. **Print receipt**
   - Receipt is created automatically
   - Print or save

### Viewing Reports

1. **Go to the home page**
   - Daily statistics are displayed on the main screen

2. **Detailed reports**
   - View charts and graphs
   - Select time range
   - Export data

## Database

### Isar Database
Savdox POS uses **Isar** database - a high-speed local database for Flutter.

### Data Models

#### Product
- `id`: Unique identifier
- `name`: Product name
- `price`: Price
- `quantity`: Quantity
- `category`: Category
- `barcode`: Barcode
- `createdAt`: Creation date

#### Order
- `id`: Unique identifier
- `orderNumber`: Order number
- `totalAmount`: Total amount
- `status`: Status
- `items`: Product list
- `createdAt`: Creation date

#### Customer
- `id`: Unique identifier
- `name`: Name
- `phone`: Phone
- `email`: Email
- `address`: Address
- `totalPurchases`: Total purchases

#### Supplier
- `id`: Unique identifier
- `name`: Name
- `phone`: Phone
- `email`: Email
- `address`: Address
- `products`: Products

### Data Backup
```bash
# Database file location:
# Android: /data/data/com.yourcompany.savdox/files/
# iOS: Library/Application Support/
# Windows: %APPDATA%/savdox/
# macOS: ~/Library/Application Support/savdox/
# Linux: ~/.local/share/savdox/
```

## Settings

### Language Settings
Savdox POS supports 3 languages:
- 🇺🇿 Uzbek
- 🇷🇺 Russian
- 🇬🇧 English

To change language:
1. Settings → Language
2. Select desired language
3. Application updates automatically

### Theme Settings
- **Light theme**: For daytime use
- **Dark theme**: For evening use
- **System**: Adapts to device settings

### Currency
- Select main currency
- Configure currency symbol
- Specify number of decimal places

## Technical Support

### Frequently Asked Questions (FAQ)

**Q: How to update the application?**
A: Download the new version via Flutter SDK and rebuild the project.

**Q: What to do if data is lost?**
A: Restore the database backup or contact technical support.

**Q: Can I work on multiple devices?**
A: Currently uses local database. Cloud synchronization will be added in future versions.

**Q: How to configure receipts?**
A: Go to Settings → Receipt Settings and change company information and format.

### Troubleshooting

#### Application won't start
1. Check Flutter SDK version
2. Run `flutter clean` command
3. Reinstall dependencies via `flutter pub get`
4. Rebuild the application

#### Database errors
1. Restart build runner:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
2. Restart the application

#### Printing issues
1. Check printer connection
2. Ensure printer drivers are installed
3. Check receipt settings

### Contact
- **Email**: support@savdox.uz
- **Telegram**: @savdox_support
- **Website**: https://savdox.uz

## License
This application is intended for personal use. A license is required for commercial use.

## Contributing
If you want to contribute to the project, submit a pull request or create an issue.

---

**Savdox POS** - Grow your business! 🚀
