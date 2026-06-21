# BookVault — Complete Project Specification
> macOS Personal Library Manager · Flutter Desktop · Local-First

---

## ⚠️ Before You Start — Read This

This file is the **single source of truth** for the BookVault project.

**Logo:** A `logo.png` file will be provided by the developer separately. When you encounter any reference to the app logo:
- Use `assets/images/logo.png` as the asset path
- Register it in `pubspec.yaml` under `flutter > assets`
- Do not generate or substitute a placeholder — leave the `Image.asset('assets/images/logo.png')` call in place so it resolves automatically once the file is added
- Use it in: the sidebar header, the app window title bar, the about section in Settings, and the loading/splash state

**Work in order.** Generate one section at a time in this sequence:
1. `pubspec.yaml` + folder structure
2. Database schema + models
3. Services (API, import/export)
4. State management
5. Theme + design system
6. Router
7. Screens (one at a time)
8. macOS config files
9. `ARCHITECTURE.md`

If you hit your output limit, stop cleanly at the end of a file. I will say "continue" and you will resume from the next file.

---

## 1. Project Overview

| Field | Value |
|---|---|
| App Name | BookVault |
| Platform | macOS Desktop (Flutter) |
| Purpose | Manage a personal physical book collection |
| Architecture | Local-first, no auth, no cloud, no backend |
| Data Storage | SQLite on-device only |
| Developer Level | Intermediate Flutter |

---

## 2. Tech Stack

| Concern | Package / Decision |
|---|---|
| Framework | Flutter Desktop — macOS target only |
| Language | Dart (latest stable) |
| Database | `drift` (SQLite ORM) — preferred over sqflite |
| State Management | **Riverpod** (`flutter_riverpod` + `riverpod_annotation`) |
| Navigation | `go_router` |
| Barcode Scanning | `mobile_scanner` (best macOS-compatible option) |
| ISBN API (primary) | Google Books API — no key required for basic use |
| ISBN API (fallback) | Open Library API |
| HTTP | `dio` |
| Image Caching | `cached_network_image` |
| Charts | `fl_chart` |
| File Picker | `file_picker` |
| UUID | `uuid` |
| Google Fonts | `google_fonts` |
| JSON Serialization | `json_serializable` + `build_runner` |
| Path Provider | `path_provider` |
| Animations | Flutter built-in + `flutter_animate` |

**Why Riverpod:** Fine-grained reactivity, excellent for filtering/searching book lists, works well with async API calls and local DB streams. Code generation via `riverpod_annotation` keeps providers clean.

**Why Drift:** Type-safe SQLite with stream support — book list updates reactively when DB changes. Better than raw sqflite for complex queries (filter by status, rating, genre).

---

## 3. Folder Structure

Generate exactly this structure. Every file listed must be created.

```
bookvault/
├── macos/
│   └── Runner/
│       ├── DebugProfile.entitlements
│       ├── Release.entitlements
│       └── Info.plist
├── assets/
│   └── images/
│       └── logo.png              ← developer will add this file manually
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   └── api_constants.dart
│   │   ├── db/
│   │   │   ├── app_database.dart
│   │   │   ├── app_database.g.dart
│   │   │   └── daos/
│   │   │       └── books_dao.dart
│   │   ├── router/
│   │   │   └── app_router.dart
│   │   └── theme/
│   │       ├── app_theme.dart
│   │       ├── app_colors.dart
│   │       └── app_typography.dart
│   ├── features/
│   │   ├── scanner/
│   │   │   ├── scanner_screen.dart
│   │   │   ├── scanner_overlay.dart
│   │   │   └── scanner_provider.dart
│   │   ├── library/
│   │   │   ├── library_screen.dart
│   │   │   ├── book_card.dart
│   │   │   ├── filter_bar.dart
│   │   │   ├── search_bar.dart
│   │   │   └── library_provider.dart
│   │   ├── book_detail/
│   │   │   ├── book_detail_screen.dart
│   │   │   ├── reading_progress_section.dart
│   │   │   ├── review_section.dart
│   │   │   ├── quotes_section.dart
│   │   │   └── book_detail_provider.dart
│   │   ├── statistics/
│   │   │   ├── statistics_screen.dart
│   │   │   ├── stats_card.dart
│   │   │   ├── genre_chart.dart
│   │   │   ├── monthly_chart.dart
│   │   │   └── statistics_provider.dart
│   │   └── settings/
│   │       ├── settings_screen.dart
│   │       └── settings_provider.dart
│   └── shared/
│       ├── models/
│       │   ├── book.dart
│       │   ├── book.g.dart
│       │   └── reading_status.dart
│       ├── services/
│       │   ├── book_lookup_service.dart
│       │   ├── export_service.dart
│       │   └── import_service.dart
│       └── widgets/
│           ├── star_rating_widget.dart
│           ├── progress_bar_widget.dart
│           ├── loading_skeleton.dart
│           ├── glass_card.dart
│           └── confirmation_dialog.dart
├── pubspec.yaml
└── ARCHITECTURE.md
```

---

## 4. macOS Entitlements

### `macos/Runner/DebugProfile.entitlements`
Must include:
```xml
<key>com.apple.security.device.camera</key>
<true/>
<key>com.apple.security.network.client</key>
<true/>
```

### `macos/Runner/Release.entitlements`
Same as above. Without these the camera will silently fail on macOS.

### `macos/Runner/Info.plist`
Add camera usage description:
```xml
<key>NSCameraUsageDescription</key>
<string>BookVault uses your camera to scan book barcodes.</string>
```

---

## 5. Database Schema (Drift)

### Table: `books`

| Column | Type | Constraints |
|---|---|---|
| id | TEXT | PRIMARY KEY (UUID) |
| isbn | TEXT | NOT NULL, UNIQUE |
| title | TEXT | NOT NULL |
| author | TEXT | NOT NULL |
| cover_image_url | TEXT | nullable |
| publisher | TEXT | nullable |
| publication_date | TEXT | nullable |
| page_count | INTEGER | nullable |
| categories | TEXT | JSON array string, nullable |
| description | TEXT | nullable |
| date_added | INTEGER | NOT NULL (Unix timestamp) |
| personal_rating | INTEGER | nullable, CHECK 1–5 |
| personal_review | TEXT | nullable |
| favorite_quotes | TEXT | JSON array string, default '[]' |
| reading_status | TEXT | NOT NULL, default 'want_to_read' |
| current_page | INTEGER | NOT NULL, default 0 |

### DAO Methods Required (`BooksDao`)
```dart
// Queries
Stream<List<BookData>> watchAllBooks();
Stream<List<BookData>> watchBooksByStatus(String status);
Future<BookData?> getBookByIsbn(String isbn);
Future<BookData?> getBookById(String id);
Future<List<BookData>> searchBooks(String query); // title + author + isbn

// Mutations
Future<int> insertBook(BooksCompanion book);
Future<bool> updateBook(BooksCompanion book);
Future<int> deleteBook(String id);

// Stats
Future<int> countByStatus(String status);
Future<double> averageRating();
Future<int> totalPagesRead();
Future<List<BookData>> getBooksAddedThisYear();
```

---

## 6. Data Model

### `ReadingStatus` enum
```dart
enum ReadingStatus {
  wantToRead,
  currentlyReading,
  finished,
  dropped;

  String toDb() => name; // snake_case for storage
  static ReadingStatus fromDb(String s) => values.firstWhere((e) => e.name == s);

  String get label => switch (this) {
    wantToRead => 'Want to Read',
    currentlyReading => 'Currently Reading',
    finished => 'Finished',
    dropped => 'Dropped',
  };
}
```

### `Book` model (`shared/models/book.dart`)
```dart
class Book {
  final String id;           // UUID v4
  final String isbn;
  final String title;
  final String author;
  final String? coverImageUrl;
  final String? publisher;
  final String? publicationDate;
  final int? pageCount;
  final List<String> categories;
  final String? description;
  final DateTime dateAdded;
  int? personalRating;       // 1–5, nullable until user rates
  String? personalReview;
  List<String> favoriteQuotes;
  ReadingStatus readingStatus;
  int currentPage;

  // Computed — no storage
  double get progressPercent {
    if (pageCount == null || pageCount! <= 0) return 0;
    return (currentPage / pageCount!).clamp(0.0, 1.0);
  }

  String get progressDisplay {
    final pct = (progressPercent * 100).toStringAsFixed(0);
    return '$pct%';
  }
}
```

Implement `fromJson`, `toJson`, `fromDbData`, `toCompanion` on the model.

---

## 7. API Integration

### `BookLookupService`

**Primary: Google Books API**
```
GET https://www.googleapis.com/books/v1/volumes?q=isbn:{ISBN}&maxResults=1
```

Map these fields from `volumeInfo`:
- `title` → title
- `authors[0]` → author (join with ", " if multiple)
- `imageLinks.thumbnail` → coverImageUrl (replace `http://` with `https://`)
- `publisher` → publisher
- `publishedDate` → publicationDate
- `pageCount` → pageCount
- `categories` → categories
- `description` → description

**Fallback: Open Library API**
```
GET https://openlibrary.org/api/books?bibkeys=ISBN:{ISBN}&format=json&jscmd=data
```

Map from the response object at key `ISBN:{ISBN}`.

**Service interface:**
```dart
class BookLookupService {
  Future<Book?> lookupByIsbn(String isbn);
  // Tries Google Books first. If result is null or throws, tries Open Library.
  // Returns null if both fail.
}
```

**Error handling:**
- Network timeout after 10 seconds
- ISBN not found → return `null` (caller shows "add manually" prompt)
- Partial data ok — only `isbn`, `title`, `author` are required; rest nullable

---

## 8. State Management (Riverpod)

### Providers to implement:

```dart
// DB instance
@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref);

// Full book list stream
@riverpod
Stream<List<Book>> bookList(BookListRef ref);

// Filtered + searched list
@riverpod
List<Book> filteredBooks(FilteredBooksRef ref); 
// Depends on: bookList, searchQuery, statusFilter, ratingFilter, genreFilter

// Active filters state
@riverpod
class BookFilters extends _$BookFilters { ... }
// State: { searchQuery, statusFilter, ratingFilter, genreFilter, sortBy }

// Single book detail
@riverpod
Book? bookDetail(BookDetailRef ref, String id);

// Statistics
@riverpod
Future<BookStats> bookStats(BookStatsRef ref);

// Theme mode
@riverpod
class ThemeMode extends _$ThemeMode { ... }
// Persisted in SharedPreferences

// Scanner state
@riverpod
class ScannerState extends _$ScannerState { ... }
// States: idle, scanning, detected(isbn), fetching, found(book), error(msg)
```

---

## 9. Design System

### Colors (`app_colors.dart`)

```dart
// Dark Theme
static const backgroundPrimary   = Color(0xFF0D0D0F);   // near-black
static const backgroundSecondary = Color(0xFF141416);   // sidebar bg
static const backgroundCard      = Color(0xFF1C1C1F);   // card bg
static const backgroundGlass     = Color(0x1AFFFFFF);   // glass overlay (10% white)
static const accentPrimary       = Color(0xFF6E56CF);   // purple accent (Linear-inspired)
static const accentSecondary     = Color(0xFF9B8AFB);   // lighter purple
static const textPrimary         = Color(0xFFF5F5F7);   // near-white
static const textSecondary       = Color(0xFF98989F);   // muted
static const textTertiary        = Color(0xFF58585E);   // very muted
static const borderSubtle        = Color(0xFF2A2A2E);   // card borders
static const starColor           = Color(0xFFFFB800);   // rating stars
static const successGreen        = Color(0xFF30D158);   // finished status
static const warningAmber        = Color(0xFFFF9F0A);   // currently reading
static const infoBlue            = Color(0xFF0A84FF);   // want to read
static const errorRed            = Color(0xFFFF453A);   // dropped / errors

// Light Theme — generate a matching light set
```

### Typography (`app_typography.dart`)
- **Primary font:** `Inter` (Google Fonts) — UI text
- **Display font:** `Fraunces` (Google Fonts) — book titles on detail screen
- Define: `displayLarge`, `titleLarge`, `titleMedium`, `bodyLarge`, `bodyMedium`, `labelLarge`, `labelSmall`

### Glassmorphism Card (`glass_card.dart`)
```dart
// Standard glass card:
// - BackdropFilter with ImageFilter.blur(sigmaX: 10, sigmaY: 10)
// - Container with Color(0x1AFFFFFF) background
// - Border: Border.all(color: Color(0x26FFFFFF), width: 1)
// - BorderRadius: 16
// - BoxShadow: subtle dark shadow
```

### Spacing Constants
```dart
static const double xs  = 4;
static const double sm  = 8;
static const double md  = 16;
static const double lg  = 24;
static const double xl  = 32;
static const double xxl = 48;
```

---

## 10. Screens — Detailed Spec

### Screen A: Home / Library Screen (`library_screen.dart`)

**Layout:**
```
┌──────────────┬─────────────────────────────────────────────┐
│   SIDEBAR    │              MAIN AREA                       │
│   200px      │                                              │
│              │  [Search Bar]          [Filter Chips]        │
│  logo.png    │                                              │
│  BookVault   │  ┌──────────────────────────────────────┐   │
│              │  │ Total │ Reading │ Finished │ Want to  │   │
│  Dashboard   │  │  42   │    3    │    28    │   11     │   │
│  Library  ←  │  └──────────────────────────────────────┘   │
│  Currently   │                                              │
│  Finished    │  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐       │
│  Wishlist    │  │ Book │ │ Book │ │ Book │ │ Book │       │
│  Statistics  │  │ Card │ │ Card │ │ Card │ │ Card │       │
│  Settings    │  └──────┘ └──────┘ └──────┘ └──────┘       │
│              │                                              │
│  [Scan Book] │                                              │
└──────────────┴─────────────────────────────────────────────┘
```

**Sidebar behavior:**
- Active item: accent-colored left border + subtle background highlight
- "Scan Book" button at bottom: full-width, accent color, camera icon
- Logo image at top from `assets/images/logo.png` — 32×32px, followed by "BookVault" text

**Analytics bar:**
- 5 cards in a row: Total Books | Currently Reading | Finished | Want to Read | Avg Rating
- Each card: number in large text + label below + subtle icon
- Cards use `GlassCard` widget

**Book Grid:**
- Responsive: `GridView` with `crossAxisCount` calculated from screen width
  - < 900px → 3 columns
  - 900–1200px → 4 columns
  - > 1200px → 5 columns
- Each `BookCard`:
  - Cover image (fill top 65% of card) with `CachedNetworkImage` + skeleton loader
  - If no cover: gradient placeholder with first letter of title
  - Bottom section: Title (1 line, ellipsis), Author (1 line, muted), progress bar (if reading), star rating (if rated)
  - Hover: scale to 1.03, shadow increases — use `MouseRegion` + `AnimatedContainer`
  - Click → navigate to book detail screen

**Search (CMD+F):**
- Focuses search bar at top
- Filters `filteredBooksProvider` in real time as user types
- Searches: title, author, ISBN

**Filter Chips (row below search):**
- Status: All | Want to Read | Reading | Finished | Dropped
- Rating: Any | ★ | ★★ | ★★★ | ★★★★ | ★★★★★ (filter ≥ N stars)
- Genre: dynamic from DB categories
- Sort: Date Added | Title | Author | Rating

---

### Screen B: Book Detail Screen (`book_detail_screen.dart`)

**Layout:**
```
┌─────────────────┬─────────────────────────────────────┐
│                 │  Title (Fraunces font, large)        │
│  Cover Image    │  Author · Publisher · Year           │
│  (full height,  │  Categories chips                    │
│   left column)  │  Description (expandable)            │
│                 │  ─────────────────────────────────── │
│                 │  READING PROGRESS                    │
│                 │  [============================] 31%  │
│                 │  Current Page: [120] / 387 pages     │
│                 │                                      │
│                 │  PERSONAL REVIEW                     │
│                 │  ★ ★ ★ ★ ☆  (interactive)          │
│                 │  [Review text area]                  │
│                 │                                      │
│                 │  FAVORITE QUOTES                     │
│                 │  "Quote one..."  [×]                 │
│                 │  "Quote two..."  [×]                 │
│                 │  [+ Add Quote]                       │
│                 │                                      │
│                 │  [Edit]              [Delete]        │
└─────────────────┴─────────────────────────────────────┘
```

**Behaviors:**
- Cover image: rounded corners, drop shadow, `CachedNetworkImage`
- Reading Progress: current page input is an inline `TextField` — saves on `onSubmitted` or focus lost
- Progress bar: animated `LinearProgressIndicator` styled with accent color
- Star Rating: interactive — tap a star to set rating, saves immediately to DB
- Review text: auto-saves after 1 second debounce (no save button)
- Favorite Quotes: each quote is a card with delete icon; "Add Quote" opens a small `AlertDialog` with a text field
- Reading Status: dropdown selector, updates DB immediately
- Delete: shows confirmation dialog before deleting
- Back navigation: left arrow at top-left

---

### Screen C: Scanner Screen / Overlay (`scanner_screen.dart`)

**Trigger:** Press `C` key or click "Scan Book" in sidebar.

**Layout:**
```
┌─────────────────────────────────────────┐
│  ╔═══════════════════════════════════╗  │
│  ║                                   ║  │
│  ║    ┌─────┐           ┌─────┐     ║  │
│  ║    │     │           │     │     ║  │  ← Corner brackets (animated)
│  ║    └─────┘           └─────┘     ║  │
│  ║    - - - - - - - - - - - - -     ║  │  ← Scanning line (animated, moves up/down)
│  ║    ┌─────┐           ┌─────┐     ║  │
│  ║    │     │           │     │     ║  │
│  ║    └─────┘           └─────┘     ║  │
│  ╚═══════════════════════════════════╝  │
│         "Point camera at barcode"       │
│              [ESC to cancel]            │
└─────────────────────────────────────────┘
```

**States:**
1. `scanning`: camera active, overlay visible, animated scan line
2. `detected`: brief flash/pulse, status text → "ISBN detected: 978XXXXXXXXX"
3. `fetching`: spinner + "Fetching book details..."
4. `found(book)`: camera closes, confirmation dialog appears
5. `error`: snackbar error, camera stays open for retry

**Confirmation Dialog (after successful scan):**
```
┌─────────────────────────────────────────────┐
│  [Cover]   Title of the Book                │
│            Author Name                      │
│            Publisher · Year · N pages       │
│                                             │
│  Status:  [Want to Read ▼]                  │
│                                             │
│  [Cancel]                    [Add to Library]│
└─────────────────────────────────────────────┘
```

**Implementation notes:**
- Use `MobileScanner` widget from `mobile_scanner` package
- `onDetect` callback: extract first barcode, pass ISBN to `BookLookupService`
- Call `controller.stop()` immediately after barcode detected (prevent re-scans)
- Scan line: `AnimationController` looping, moves a `Container` with gradient vertically
- Corner brackets: drawn with `CustomPainter`

---

### Screen D: Statistics Screen (`statistics_screen.dart`)

**Top stats cards (row of 4):**
- Total Books Owned
- Books Read This Year
- Average Rating (e.g. "4.2 ★")
- Total Pages Read

**Charts section:**
1. **Books by Genre** — Donut chart (`PieChart` from fl_chart)
   - Each genre = one segment, legend on the right
   - Tap segment to highlight + show count

2. **Books Added by Month** — Bar chart (`BarChart` from fl_chart)
   - Last 12 months on X axis
   - Count of books added per month on Y axis

3. **Reading Status Distribution** — Horizontal bar or second pie chart
   - Want to Read / Reading / Finished / Dropped

**Reading Streak:**
- Count consecutive days where `date_added` or last page update exists
- Display as: "🔥 7 day streak" card

---

### Screen E: Settings Screen (`settings_screen.dart`)

**Sections:**
1. **Appearance**
   - Dark Mode / Light Mode toggle switch
   - Logo preview from `assets/images/logo.png`

2. **Data Management**
   - Export as CSV button
   - Export as JSON button
   - Import from CSV button
   - Import from JSON button
   - One-click backup (exports JSON to `~/Documents/BookVault/backups/backup_{timestamp}.json`)

3. **About**
   - App name + logo
   - Version: 1.0.0
   - "Built with Flutter"

---

## 11. Scanner — Keyboard Shortcuts

Implement using Flutter's `Shortcuts` + `Actions` system (not `RawKeyboardListener` which is deprecated):

```dart
// Register these at the top-level MaterialApp or a high-level widget:
shortcuts: {
  SingleActivator(LogicalKeyboardKey.keyC):         ScanBookIntent(),
  SingleActivator(LogicalKeyboardKey.keyF, meta: true): SearchIntent(),
  SingleActivator(LogicalKeyboardKey.keyN, meta: true): AddBookManuallyIntent(),
  SingleActivator(LogicalKeyboardKey.delete):       DeleteBookIntent(),
  SingleActivator(LogicalKeyboardKey.escape):       CloseOverlayIntent(),
},
```

Each `Intent` maps to an `Action` that calls the relevant Riverpod provider method.

---

## 12. Import / Export Service

### Export
```dart
class ExportService {
  Future<void> exportAsJson(List<Book> books, String outputPath);
  Future<void> exportAsCsv(List<Book> books, String outputPath);
  Future<void> createBackup(List<Book> books);
  // Backup path: ~/Documents/BookVault/backups/backup_{yyyyMMdd_HHmmss}.json
}
```

**CSV columns:** `isbn, title, author, publisher, publication_date, page_count, categories, date_added, personal_rating, personal_review, reading_status, current_page`

**JSON format:** Array of book objects using `Book.toJson()`

### Import
```dart
class ImportService {
  Future<ImportResult> importFromJson(String filePath, BooksDao dao);
  Future<ImportResult> importFromCsv(String filePath, BooksDao dao);
}

class ImportResult {
  final int imported;
  final int skipped; // duplicates by ISBN
  final List<String> errors;
}
```
- Upsert logic: if ISBN already exists in DB, skip (do not overwrite)
- Show result snackbar: "Imported 12 books. 3 skipped (duplicates)."

---

## 13. Shared Widgets

### `StarRatingWidget`
- Parameters: `rating` (int? 1–5), `onRatingChanged` (callback), `size` (double), `readOnly` (bool)
- Interactive mode: hover effect per star, click to set
- Display mode: filled/unfilled stars with `starColor`

### `ProgressBarWidget`
- Parameters: `progress` (0.0–1.0), `currentPage`, `totalPages`
- Shows: animated `LinearProgressIndicator` + `"120 / 387 pages (31%)"`

### `LoadingSkeleton`
- A `Shimmer`-style animated grey box for book cards while loading
- Matches the dimensions of a `BookCard`

### `GlassCard`
- Parameters: `child`, `padding`, `borderRadius`
- Wraps in `BackdropFilter` + `ClipRRect` + translucent container

### `ConfirmationDialog`
- Parameters: `title`, `message`, `confirmLabel`, `onConfirm`
- Used for: delete book confirmation

---

## 14. Error Handling

| Scenario | Behavior |
|---|---|
| Camera unavailable | Show error state in scanner screen: icon + "Camera not available" + close button |
| ISBN not found in both APIs | Close scanner, show dialog: "Book not found. Add manually?" with [Cancel] and [Add Manually] buttons |
| Network timeout | Snackbar: "Could not fetch book info. Check your connection." |
| DB error on insert | Snackbar: "Failed to save book. Try again." — log to console |
| Import file invalid | Snackbar: "Invalid file format. Please use a BookVault export file." |
| Duplicate ISBN on scan | Show confirmation: "This book is already in your library. View it?" |

---

## 15. `pubspec.yaml` — Full Dependencies

```yaml
name: bookvault
description: Personal Library Manager for macOS
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.10.0'

dependencies:
  flutter:
    sdk: flutter
  # State
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0
  # DB
  drift: ^2.14.0
  sqlite3_flutter_libs: ^0.5.0
  path_provider: ^2.1.0
  path: ^1.8.0
  # Navigation
  go_router: ^13.0.0
  # Network
  dio: ^5.4.0
  # Barcode
  mobile_scanner: ^4.0.0
  # Images
  cached_network_image: ^3.3.0
  # UI
  google_fonts: ^6.1.0
  fl_chart: ^0.66.0
  flutter_animate: ^4.3.0
  # Utils
  uuid: ^4.2.0
  intl: ^0.19.0
  file_picker: ^8.0.0
  shared_preferences: ^2.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.0
  drift_dev: ^2.14.0
  riverpod_generator: ^2.3.0
  json_serializable: ^6.7.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

---

## 16. `ARCHITECTURE.md`

Generate this file with these sections:
1. **Package Decisions** — why each major package was chosen
2. **State Management** — how Riverpod providers are structured, data flow diagram (text-based)
3. **Database Design** — schema rationale, why Drift
4. **Feature Folder Structure** — what goes in each folder and why
5. **API Strategy** — primary/fallback pattern for book lookup
6. **Known Limitations & Phase 2 Notes** — what's deferred and where to hook it in

---

## 17. Animations Checklist

Implement all of these:

- [ ] Page transitions: `FadeTransition` + 20px vertical slide (via `go_router` `pageBuilder`)
- [ ] Book card hover: `AnimatedContainer` scale 1.0→1.03 + shadow increase, duration 150ms
- [ ] Scanner line: looping vertical translation animation, 1.5s per cycle
- [ ] Progress bar: `TweenAnimationBuilder` from 0 to actual value on first render, 600ms
- [ ] Stats cards: `flutter_animate` staggered fade-in on load, 80ms between each
- [ ] Cover image: `FadeInImage` / `CachedNetworkImage` with `fadeInDuration`
- [ ] Loading skeleton: pulsing opacity animation (0.4→0.8→0.4, looping)
- [ ] Confirmation dialog: scale + fade in, 200ms

---

## 18. What NOT to Build (Out of Scope for v1)

Do not generate code for these — they are Phase 2/3:
- OCR scanning (books without barcode)
- AI-generated summaries
- Reading goals or reminders
- Book recommendations engine
- Mobile companion app
- Cloud sync or multi-device support
- User authentication
- Any backend service

---

## 19. Completion Checklist

Before declaring the project complete, verify:

- [ ] App compiles and runs on macOS with `flutter run -d macos`
- [ ] Camera entitlements are set in both Debug and Release plist files
- [ ] `assets/images/` folder is registered in `pubspec.yaml`
- [ ] `logo.png` path is referenced (not hardcoded content) — developer adds the file
- [ ] All 5 screens are navigable via sidebar
- [ ] Barcode scan → API fetch → save to DB full flow works end to end
- [ ] Dark mode is default; Light mode toggles correctly
- [ ] Export CSV and Export JSON produce valid files
- [ ] Import correctly skips duplicates and shows result count
- [ ] Keyboard shortcuts C, CMD+F, CMD+N, DELETE, ESC all work
- [ ] `ARCHITECTURE.md` is generated

---

*End of BookVault Project Specification v1.0*