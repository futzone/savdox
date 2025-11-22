# O'zgarishlar tarixi / Changelog

Barcha muhim o'zgarishlar ushbu faylda hujjatlashtiriladi.

Format [Keep a Changelog](https://keepachangelog.com/uz/1.0.0/) asosida,
va ushbu loyiha [Semantic Versioning](https://semver.org/spec/v2.0.0.html) dan foydalanadi.

## [1.0.0] - 2025-11-22

### ✨ Qo'shilgan
- **Asosiy funksiyalar**
  - Mahsulotlarni boshqarish tizimi
  - Buyurtmalar va hisob-kitob moduli
  - Mijozlar va yetkazib beruvchilar bazasi
  - Hisobotlar va tahlil paneli
  - Ko'p tilli interfeys (O'zbek, Rus, Ingliz)
  
- **Ma'lumotlar bazasi**
  - Isar ma'lumotlar bazasi integratsiyasi
  - Mahsulot modeli (Product)
  - Buyurtma modeli (Order)
  - Mijoz modeli (Customer)
  - Yetkazib beruvchi modeli (Supplier)
  - To'lov turi modeli (PaymentType)
  - Tranzaksiya modeli (Transaction)
  - Xarid modeli (Shopping)
  - Xodim modeli (Employee)

- **Foydalanuvchi interfeysi**
  - Asosiy ekran (MainScreen) - navigatsiya paneli bilan
  - Bosh sahifa (HomeScreen) - statistika va grafiklar
  - Mahsulotlar ekrani (ProductsScreen) - mahsulotlar ro'yxati
  - Mahsulot shakli (ProductFormScreen) - mahsulot qo'shish/tahrirlash
  - Hisob-kitob ekrani (BillingScreen) - savdo jarayoni
  - Buyurtma shakli (OrderFormScreen) - buyurtma yaratish
  - Boshqalar ekrani (OthersScreen) - qo'shimcha funksiyalar
  - Yetkazib beruvchilar ekrani (SuppliersScreen)
  - Sozlamalar ekrani - til, mavzu, profil
  - FAQ ekrani - tez-tez so'raladigan savollar
  - Hujjatlar ekrani - yordam va qo'llanmalar

- **Vizual dizayn**
  - Material Design 3 qo'llab-quvvatlash
  - Yorug' va qorong'i mavzu
  - Adaptiv dizayn - barcha qurilmalar uchun
  - Grafiklar va diagrammalar (fl_chart)

- **Sozlamalar**
  - Til tanlash funksiyasi
  - Mavzu o'zgartirish (Yorug'/Qorong'i/Tizim)
  - Foydalanuvchi profili
  - Ilova sozlamalari

- **Texnik xususiyatlar**
  - Flutter 3.9.2+ qo'llab-quvvatlash
  - Hooks Riverpod state management
  - Path provider - fayl tizimi
  - Intl - xalqarolashtirish
  - Cross-platform qo'llab-quvvatlash (Android, iOS, Windows, macOS, Linux, Web)

### 🔧 O'zgartirilgan
- Loyiha strukturasi optimallashtirildi
- Kod tashkiloti yaxshilandi
- Performance optimizatsiyalari

### 🐛 Tuzatilgan
- Isar ma'lumotlar bazasi konfiguratsiya muammolari
- Android build xatolari
- Namespace muammolari

### 📚 Hujjatlar
- DOCS_UZ.md - To'liq O'zbek hujjatlari
- DOCS_RU.md - To'liq Rus hujjatlari  
- DOCS_EN.md - To'liq Ingliz hujjatlari
- CHANGELOG_UZ.md - O'zgarishlar tarixi (O'zbek)
- CHANGELOG_RU.md - O'zgarishlar tarixi (Rus)
- CHANGELOG_EN.md - O'zgarishlar tarixi (Ingliz)
- README.md yangilandi

### 🔒 Xavfsizlik
- Lokal ma'lumotlar bazasi xavfsizligi
- Ma'lumotlar shifrlash tayyorgarlik

---

## Kelajak rejalari

### [1.1.0] - Rejalashtirilmoqda
- [ ] Bulutli sinxronizatsiya
- [ ] Chek chop etish funksiyasi
- [ ] Shtrix-kod skanerlash
- [ ] Inventarizatsiya boshqaruvi
- [ ] Ko'proq hisobot turlari
- [ ] Excel/PDF eksport
- [ ] Foydalanuvchi rollari va ruxsatlari
- [ ] Zaxira nusxa olish va tiklash

### [1.2.0] - Rejalashtirilmoqda
- [ ] Onlayn to'lov integratsiyasi
- [ ] SMS bildirishnomalar
- [ ] Email hisobotlar
- [ ] Mobil ilova versiyasi
- [ ] Telegram bot integratsiyasi
- [ ] Loyallik dasturi
- [ ] Aksiyalar va chegirmalar tizimi

### [2.0.0] - Uzoq muddatli
- [ ] AI-asoslangan tahlil
- [ ] Bashorat qilish tizimi
- [ ] Multi-filial qo'llab-quvvatlash
- [ ] CRM integratsiyasi
- [ ] Buxgalteriya tizimi integratsiyasi
- [ ] API va uchinchi tomon integratsiyalari

---

## Versiya nomenklaturasi

Ushbu loyiha **Semantic Versioning** dan foydalanadi:

- **MAJOR** (1.x.x) - API o'zgarishlari, orqaga mos kelmaydigan o'zgarishlar
- **MINOR** (x.1.x) - Yangi funksiyalar, orqaga mos keluvchi
- **PATCH** (x.x.1) - Xatolarni tuzatish, kichik yaxshilanishlar

## O'zgarishlar turlari

- **✨ Qo'shilgan** - Yangi funksiyalar
- **🔧 O'zgartirilgan** - Mavjud funksiyalardagi o'zgarishlar
- **❌ O'chirilgan** - O'chirilgan funksiyalar
- **🐛 Tuzatilgan** - Xatolarni tuzatish
- **🔒 Xavfsizlik** - Xavfsizlik yaxshilanishlari
- **📚 Hujjatlar** - Hujjatlar o'zgarishlari
- **⚡ Performance** - Ishlash tezligi yaxshilanishlari
- **♻️ Refaktoring** - Kod qayta tuzilishi

---

**Savdox POS** - Doimiy rivojlanish! 🚀
