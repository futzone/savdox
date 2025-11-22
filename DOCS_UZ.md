# Savdox POS - Hujjatlar (O'zbekcha)

## Mundarija
- [Kirish](#kirish)
- [O'rnatish](#ornatish)
- [Tizim talablari](#tizim-talablari)
- [Xususiyatlar](#xususiyatlar)
- [Foydalanish bo'yicha qo'llanma](#foydalanish-boyicha-qollanma)
- [Ma'lumotlar bazasi](#malumotlar-bazasi)
- [Sozlamalar](#sozlamalar)
- [Texnik yordam](#texnik-yordam)

## Kirish

**Savdox POS** - bu zamonaviy savdo nuqtasi (Point of Sale) tizimi bo'lib, Flutter yordamida ishlab chiqilgan. Dastur mahsulotlar, buyurtmalar, mijozlar va yetkazib beruvchilarni boshqarish uchun to'liq funksionallikni taqdim etadi.

### Asosiy maqsad
Savdox POS kichik va o'rta bizneslar uchun sodda, tez va samarali savdo jarayonlarini ta'minlash uchun yaratilgan.

## O'rnatish

### 1. Flutter SDK o'rnatish
```bash
# Flutter SDK yuklab oling va o'rnating
# https://docs.flutter.dev/get-started/install
```

### 2. Loyihani klonlash
```bash
git clone <repository-url>
cd savdox
```

### 3. Bog'liqliklarni o'rnatish
```bash
flutter pub get
```

### 4. Isar ma'lumotlar bazasini yaratish
```bash
flutter pub run build_runner build
```

### 5. Ilovani ishga tushirish
```bash
flutter run
```

## Tizim talablari

### Minimal talablar
- **Flutter SDK**: 3.9.2 yoki yuqori
- **Dart SDK**: 3.9.2 yoki yuqori
- **Xotira**: 4 GB RAM (tavsiya etiladi: 8 GB)
- **Disk maydoni**: 500 MB bo'sh joy

### Qo'llab-quvvatlanadigan platformalar
- ✅ Android (5.0 va yuqori)
- ✅ iOS (11.0 va yuqori)
- ✅ Windows (10 va yuqori)
- ✅ macOS (10.14 va yuqori)
- ✅ Linux
- ✅ Web

## Xususiyatlar

### 📦 Mahsulotlarni boshqarish
- Mahsulot qo'shish, tahrirlash va o'chirish
- Mahsulot kategoriyalari
- Narxlar va chegirmalar
- Inventarizatsiya nazorati
- Shtrix-kod qo'llab-quvvatlash

### 🛒 Buyurtmalar tizimi
- Yangi buyurtma yaratish
- Buyurtma holatini kuzatish
- Buyurtma tarixini ko'rish
- Chek chop etish

### 💰 Hisob-kitob (Billing)
- Tez va qulay hisob-kitob interfeysi
- Bir nechta to'lov usullari
- Chegirmalar va aksiyalar
- Chek yaratish va chop etish

### 👥 Mijozlarni boshqarish
- Mijozlar bazasi
- Mijoz tarixi
- Sodiqlik dasturi
- Kontakt ma'lumotlari

### 🚚 Yetkazib beruvchilar
- Yetkazib beruvchilar ro'yxati
- Kontakt ma'lumotlari
- Yetkazib berish tarixi
- Hisob-kitoblar

### 📊 Hisobotlar va tahlil
- Kunlik/haftalik/oylik savdo hisobotlari
- Grafik va diagrammalar (fl_chart yordamida)
- Eng ko'p sotiladigan mahsulotlar
- Daromad tahlili

### ⚙️ Sozlamalar
- Til tanlash (O'zbek, Rus, Ingliz)
- Mavzu (Yorug'/Qorong'i)
- Valyuta sozlamalari
- Chek sozlamalari
- Foydalanuvchi profili

## Foydalanish bo'yicha qo'llanma

### Birinchi ishga tushirish

1. **Ilovani oching**
   - Ilova ochilganda asosiy ekran ko'rinadi

2. **Sozlamalarni o'rnating**
   - Sozlamalar bo'limiga o'ting
   - Tilni tanlang
   - Valyutani sozlang
   - Kompaniya ma'lumotlarini kiriting

### Mahsulot qo'shish

1. **Mahsulotlar bo'limiga o'ting**
   - Asosiy menyudan "Mahsulotlar" tugmasini bosing

2. **Yangi mahsulot qo'shish**
   - "+" tugmasini bosing
   - Mahsulot ma'lumotlarini kiriting:
     - Nomi
     - Narxi
     - Kategoriya
     - Miqdori
     - Shtrix-kod (ixtiyoriy)
   - "Saqlash" tugmasini bosing

### Buyurtma yaratish

1. **Hisob-kitob ekraniga o'ting**
   - Asosiy menyudan "Hisob-kitob" tugmasini bosing

2. **Mahsulotlarni tanlang**
   - Mahsulotlarni qidiruv orqali toping
   - Yoki shtrix-kod skanerlang
   - Miqdorni kiriting

3. **To'lovni amalga oshiring**
   - To'lov usulini tanlang
   - Summani kiriting
   - "To'lash" tugmasini bosing

4. **Chekni chop eting**
   - Chek avtomatik yaratiladi
   - Chop etish yoki saqlash

### Hisobotlarni ko'rish

1. **Bosh sahifaga o'ting**
   - Asosiy ekranda kunlik statistika ko'rinadi

2. **Batafsil hisobotlar**
   - Grafik va diagrammalarni ko'ring
   - Vaqt oralig'ini tanlang
   - Ma'lumotlarni eksport qiling

## Ma'lumotlar bazasi

### Isar Database
Savdox POS **Isar** ma'lumotlar bazasidan foydalanadi - bu Flutter uchun yuqori tezlikdagi lokal ma'lumotlar bazasi.

### Ma'lumotlar modellari

#### Product (Mahsulot)
- `id`: Noyob identifikator
- `name`: Mahsulot nomi
- `price`: Narx
- `quantity`: Miqdor
- `category`: Kategoriya
- `barcode`: Shtrix-kod
- `createdAt`: Yaratilgan sana

#### Order (Buyurtma)
- `id`: Noyob identifikator
- `orderNumber`: Buyurtma raqami
- `totalAmount`: Umumiy summa
- `status`: Holat
- `items`: Mahsulotlar ro'yxati
- `createdAt`: Yaratilgan sana

#### Customer (Mijoz)
- `id`: Noyob identifikator
- `name`: Ism
- `phone`: Telefon
- `email`: Email
- `address`: Manzil
- `totalPurchases`: Umumiy xaridlar

#### Supplier (Yetkazib beruvchi)
- `id`: Noyob identifikator
- `name`: Nomi
- `phone`: Telefon
- `email`: Email
- `address`: Manzil
- `products`: Mahsulotlar

### Ma'lumotlarni zaxiralash
```bash
# Ma'lumotlar bazasi fayli joylashuvi:
# Android: /data/data/com.yourcompany.savdox/files/
# iOS: Library/Application Support/
# Windows: %APPDATA%/savdox/
# macOS: ~/Library/Application Support/savdox/
# Linux: ~/.local/share/savdox/
```

## Sozlamalar

### Til sozlamalari
Savdox POS 3 ta tilni qo'llab-quvvatlaydi:
- 🇺🇿 O'zbek
- 🇷🇺 Rus
- 🇬🇧 Ingliz

Tilni o'zgartirish uchun:
1. Sozlamalar → Til
2. Kerakli tilni tanlang
3. Ilova avtomatik yangilanadi

### Mavzu sozlamalari
- **Yorug' mavzu**: Kunduzgi foydalanish uchun
- **Qorong'i mavzu**: Kechki foydalanish uchun
- **Tizim**: Qurilma sozlamalariga moslashadi

### Valyuta
- Asosiy valyutani tanlang
- Valyuta belgisini sozlang
- O'nlik kasrlar sonini belgilang

## Texnik yordam

### Tez-tez so'raladigan savollar (FAQ)

**S: Ilovani qanday yangilash mumkin?**
J: Flutter SDK orqali yangi versiyani yuklab oling va qayta build qiling.

**S: Ma'lumotlar yo'qolsa nima qilish kerak?**
J: Ma'lumotlar bazasi zaxira nusxasini tiklang yoki texnik yordam bilan bog'laning.

**S: Bir nechta qurilmada ishlash mumkinmi?**
J: Hozircha lokal ma'lumotlar bazasi ishlatiladi. Bulutli sinxronizatsiya keyingi versiyalarda qo'shiladi.

**S: Chekni qanday sozlash mumkin?**
J: Sozlamalar → Chek sozlamalari bo'limida kompaniya ma'lumotlari va formatni o'zgartiring.

### Muammolarni hal qilish

#### Ilova ishga tushmayapti
1. Flutter SDK versiyasini tekshiring
2. `flutter clean` buyrug'ini bajaring
3. `flutter pub get` orqali bog'liqliklarni qayta o'rnating
4. Ilovani qayta build qiling

#### Ma'lumotlar bazasi xatolari
1. Build runner'ni qayta ishga tushiring:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
2. Ilovani qayta ishga tushiring

#### Chop etish muammolari
1. Printer ulanganligini tekshiring
2. Printer drayverlari o'rnatilganligini tasdiqlang
3. Chek sozlamalarini tekshiring

### Bog'lanish
- **Email**: support@savdox.uz
- **Telegram**: @savdox_support
- **Veb-sayt**: https://savdox.uz

## Litsenziya
Bu dastur shaxsiy foydalanish uchun mo'ljallangan. Tijorat maqsadlarda foydalanish uchun litsenziya talab qilinadi.

## Hissa qo'shish
Loyihaga hissa qo'shmoqchi bo'lsangiz, pull request yuboring yoki issue yarating.

---

**Savdox POS** - Biznesingizni rivojlantiring! 🚀
