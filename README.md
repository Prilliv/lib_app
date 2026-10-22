# Практична робота 7 — Варіант 1: Бібліотека коледжу

Застосунок для пошуку і бронювання книг бібліотеки коледжу на Flutter + go_router 17.x.

## Вимоги

- Flutter 3.29+ (Dart 3.7+)
- go_router: ^17.0.0

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
