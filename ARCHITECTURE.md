# BookVault Architecture

BookVault is a native macOS Flutter application built with a focus on local-first data, high performance, and minimal aesthetics. This document outlines the core technical decisions and module structures used in the project.

## Tech Stack Overview

1. **State Management**: `riverpod` (with `riverpod_generator`)
   Provides a reactive, compile-time safe dependency injection and state management solution.
2. **Local Database**: `drift` (SQLite)
   A type-safe SQLite abstraction for local data persistence without network reliance.
3. **Routing**: `go_router`
   A declarative router utilizing a ShellRoute for a continuous sidebar navigation layout.
4. **Networking**: `dio`
   Handles HTTP requests to public book APIs (Open Library & Google Books) for fetching metadata.
5. **Scanning**: `mobile_scanner`
   Enables Mac webcams to scan ISBN barcodes natively.

## Directory Structure (Feature-First Architecture)

The app utilizes a feature-driven architecture structure inside `lib/`:

*   **`core/`**: Foundational app configurations that are independent of any feature.
    *   `constants/`: App-wide static values and configurations.
    *   `db/`: Drift database configurations, DAOs, and table definitions.
    *   `router/`: `go_router` definitions and path management.
    *   `theme/`: Design tokens (Colors, Typography, Themes).
*   **`features/`**: Feature-specific UI and business logic.
    *   `book_detail/`: Reading progress tracking, rating/review inputs, quotes.
    *   `library/`: Book grid, search, filter chips, and top-level analytics.
    *   `scanner/`: Custom webcam overlay, ISBN barcode detection, fetching state.
    *   `settings/`: Appearance toggles, JSON import/export.
    *   `statistics/`: fl_chart implementations (Pie charts, Bar charts, Streaks).
*   **`shared/`**: Code utilized by multiple features.
    *   `models/`: Shared data models (e.g., `Book`, `ReadingStatus`).
    *   `services/`: External integrations (`BookLookupService`, `ExportService`).
    *   `widgets/`: Reusable UI components (`GlassCard`, `ConfirmationDialog`, `StarRating`).

## Core Concepts

### 1. Data Flow & Riverpod
All features communicate with the database via Riverpod providers.
`appDatabaseProvider` serves as the root dependency for `BooksDao`.
Feature-specific providers (e.g., `bookListProvider`) stream data directly from Drift tables using `.watch()`, meaning UI automatically updates whenever a book is inserted, updated, or deleted without manual refreshes.

### 2. Network Isolation (Book Lookup)
`BookLookupService` accepts an ISBN and queries the Open Library API first. If unsuccessful or incomplete, it falls back to the Google Books API. The service returns a transient `Book` object that is only saved to the database upon user confirmation.

### 3. Responsive macOS Layout
The application relies on `LayoutBuilder` across core views (e.g., `LibraryScreen`) to dynamically adapt column counts for the book grid based on the active window size. A custom `SidebarLayout` acts as the `ShellRoute` wrapper, mimicking native macOS applications.

### 4. Entitlements
Because BookVault runs as a macOS desktop app, specific sandbox entitlements have been configured in `DebugProfile.entitlements` and `Release.entitlements`:
*   `com.apple.security.network.client`: Allowed (for API lookups).
*   `com.apple.security.device.camera`: Allowed (for barcode scanning).
*   `com.apple.security.files.user-selected.read-write`: Allowed (for JSON export/import via native file picker).
