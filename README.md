# Практична робота 7 — Варіант 1: Бібліотека коледжу

Застосунок для пошуку і бронювання книг бібліотеки коледжу на Flutter + go_router 17.x.

## Вимоги

- Flutter 3.29+ (Dart 3.7+)
- go_router: ^17.0.0

## Запуск

```bash
flutter pub get
flutter run
```

## Карта маршрутів

| Шлях | Екран | Захист |
|------|-------|--------|
| `/catalog?genre=...` | CatalogScreen | — |
| `/catalog/book/:bookId` | BookScreen | — |
| `/catalog/book/:bookId/reserve` | ReserveScreen | потрібен вхід |
| `/catalog/book/:bookId/reserve/date` | DatePickerScreen | — |
| `/my-books` | MyBooksScreen | — |
| `/profile` | ProfileScreen | — |
| `/login?from=...` | LoginScreen | — |

- Нижня навігація: `StatefulShellRoute.indexedStack` (Каталог / Мої книги / Профіль).
- Екран бронювання відкривається поверх панелі (`parentNavigatorKey`).
- Guard: `redirect` + `refreshListenable` (authService). Після входу — повернення на початкову адресу.
- Повернення дати: `context.push<DateTime>(...)` → `context.pop(date)`.
- `PopScope` на екранах бронювання та профілю.
- `errorBuilder` для невідомих адрес.

## Deep link

Схема: `library://app/...`

### Android (adb)

```bash
adb shell am start -a android.intent.action.VIEW \
  -d "library://app/catalog/book/5"
```

### iOS (симулятор)

```bash
xcrun simctl openurl booted "library://app/catalog/book/5"
```

Після відкриття deep link «Назад» веде до каталогу.

## Що показати (чекліст)

1. Відкрити книгу → перейти в «Профіль» → повернутися: книга на місці (стан вкладки зберігається).
2. Бронювання без входу → екран входу → автоматичне повернення до бронювання.
3. Deep link через adb/simctl відкриває книгу; «Назад» — до каталогу.
4. Вибір дати повернення повертає значення на екран бронювання.
5. PopScope: вихід з незбереженими змінами — лише після підтвердження.

## Структура

```
lib/
  main.dart
  router.dart
  models/
    book.dart
    reservation.dart
  services/
    auth_service.dart
    book_service.dart
  screens/
    catalog_screen.dart
    book_screen.dart
    reserve_screen.dart
    date_picker_screen.dart
    my_books_screen.dart
    profile_screen.dart
    login_screen.dart
    error_screen.dart
    scaffold_with_nav.dart
```

## Труднощі та розв'язання

- **go_router 17 потребує Dart ≥ 3.7** — використовуйте Flutter 3.29+.
- **Збереження стану вкладок** — `StatefulShellRoute.indexedStack` + `goBranch`.
- **Reserve поверх bottom bar** — `parentNavigatorKey: rootNavigatorKey`.
- **Повернення після login** — query-параметр `from` у redirect і на LoginScreen.
- **Deep link без App Links** — власна схема `library` в AndroidManifest і Info.plist.

## Аналіз

```bash
flutter analyze
```

Має бути без попереджень.
