# Instagram Feed Clone — Flutter

A pixel-perfect replication of the Instagram Home Feed built with Flutter.

---

## 📱 Demo

> Screen recording showing:
> - Shimmer loading state on first launch
> - Smooth infinite scroll with pagination
> - Pinch-to-Zoom overlay with snap-back animation
> - Double-tap heart animation
> - Like / Save toggle interactions
> - Expandable captions with hashtag coloring

---

## 🏗️ Architecture & State Management

### State Management: Provider

I chose **Provider** (`provider: ^6.1.2`) for the following reasons:

- **Simplicity with correctness** — The feed has one primary piece of shared state (the list of posts). Provider handles this cleanly without the boilerplate overhead of BLoC or the learning curve of Riverpod.
- **`ChangeNotifier` + `context.watch`** — `FeedProvider` extends `ChangeNotifier` and exposes `posts`, `isLoading`, and pagination state. The `HomeFeedScreen` rebuilds only when `notifyListeners()` is called, keeping rebuilds minimal.
- **Local UI state stays local** — Animations (`_DoubleTapLikeWrapper`, `_ExpandableCaption`, `PinchZoomImage`) manage their own state with `StatefulWidget`, keeping the provider lean and focused only on data.

### Folder Structure

```
lib/
├── models/
│   └── post_model.dart          # Pure data class — Post with all fields
├── services/
│   └── post_repository.dart     # Mock data layer with 1.5s latency simulation
├── providers/
│   └── feed_provider.dart       # ChangeNotifier — posts, pagination, like/save
├── screens/
│   └── home_feed_screen.dart    # Single screen — AppBar, feed, bottom nav
└── widgets/
    ├── stories_list.dart        # Horizontal stories tray
    ├── story_item.dart          # Individual story with gradient ring / "Your story"
    ├── post_card.dart           # Full post card with all interactions
    ├── carousel_images.dart     # PageView with dot indicator and image counter
    ├── pinch_zoom_image.dart    # Overlay-based pinch-to-zoom with snap-back
    └── post_shimmer.dart        # Shimmer skeleton matching exact post layout
```

---

## ✨ Features Implemented

| Feature | Details |
|---|---|
| Stories tray | Horizontal scroll, gradient ring, "Your story" with + badge |
| Post feed | Avatar, username, location, image, actions, like count, caption, comments, timestamp |
| Carousel posts | PageView with image counter ("1 / 3") and expanding dot indicator |
| Pinch-to-Zoom | Full-screen overlay, background darkens on zoom, smooth snap-back animation |
| Double-tap like | Animated white heart scales in/out over the image |
| Like toggle | Heart fills red, count increments/decrements, persists during session |
| Save toggle | Bookmark fills on tap |
| Expandable caption | Truncates at 2 lines with "more" tap to expand |
| Hashtag coloring | `#hashtags` and `@mentions` render in Instagram blue |
| Shimmer loading | Skeleton matching exact post layout shown during 1.5s initial load |
| Infinite scroll | Triggers next page fetch when 300px from bottom, appends seamlessly |
| Pagination loader | Spinner shown at bottom while next page loads |
| Snackbar feedback | Floating rounded snackbar for unimplemented actions (Comments, Share, Options) |
| Error handling | Broken image icon shown when network image fails to load |
| Cached images | `cached_network_image` handles memory and disk caching |
| Bottom navigation | 5 tabs with filled/outlined icon toggle on active tab |

---

## 🚀 How to Run

### Prerequisites
- Flutter SDK `>=3.8.1`
- Dart SDK `>=3.0.0`
- Android emulator / iOS simulator / physical device
- Internet connection (images and Google Fonts load from network)

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/instagram_clone.git
cd instagram_clone

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Build APK (Android)

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Build IPA (iOS)

```bash
flutter build ios --release
```

---

## 📦 Dependencies

| Package | Version | Purpose |
|---|---|---|
| `provider` | ^6.1.2 | State management |
| `cached_network_image` | ^3.3.1 | Image caching (memory + disk) |
| `shimmer` | ^3.0.0 | Skeleton loading animation |
| `smooth_page_indicator` | ^1.1.0 | Carousel dot indicator |
| `google_fonts` | ^6.3.2 | Pacifico font for Instagram logo |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |

---

## 🔑 Key Technical Decisions

**Pinch-to-Zoom via OverlayEntry** — Instead of using `InteractiveViewer` (which clips to widget bounds), the zoom uses Flutter's `Overlay` to insert the zoomed image above the entire widget tree. `RenderBox.localToGlobal` captures the widget's exact screen position so the overlay image starts at the same location as the original.

**Pagination trigger at 300px** — The `ScrollController` listener fires `loadPosts()` when the user is 300px from the bottom, which at average post height equals roughly 2 posts away — matching the requirement exactly.

**Local animation state** — `_DoubleTapLikeWrapper` and `_ExpandableCaption` are private `StatefulWidget` classes inside their respective files. This keeps animation logic isolated and `PostCard` itself a `StatelessWidget`, which means it only rebuilds when the provider notifies (like/save changes), not on every animation frame.

**Image URLs with `?w=600`** — All Unsplash URLs include a width parameter to request 600px images instead of full resolution, reducing memory usage significantly during infinite scroll.
