<h1 align="center">SG60 Heritage Lens — The Swifties</h1>

<p align="center">Discover Singapore’s heritage through your camera.</p>

<p align="center">
	<img alt="iOS" src="https://img.shields.io/badge/iOS-15%2B-black?logo=apple" />
	<img alt="Swift" src="https://img.shields.io/badge/Swift-5.9-orange?logo=swift" />
	<img alt="SwiftUI" src="https://img.shields.io/badge/SwiftUI-%E2%9C%94-blue" />
	<img alt="Core ML" src="https://img.shields.io/badge/Core%20ML%20%2B%20Vision-on%20device-brightgreen" />
	<img alt="PRs welcome" src="https://img.shields.io/badge/PRs-welcome-brightgreen" />
</p>

Discover Singapore’s heritage through your camera. This SwiftUI iOS app uses a Core ML model to recognize landmarks, foods, transport, and cultural icons, then shares bite‑sized history while you earn badges and track progress.

Note: This project was created for a competition and is open to contributions.

---

## Table of Contents

- [Features at a glance](#features-at-a-glance)
- [Tech stack](#tech-stack)
- [App structure (key files)](#app-structure-key-files)
- [How the scanner works](#how-the-scanner-works-high-level)
- [Getting started](#getting-started)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [Roadmap](#roadmap-non-exhaustive)
- [Troubleshooting](#troubleshooting)
- [License](#license)
- [Acknowledgements](#acknowledgements)

 

## Features at a glance

- 📸 Landmark scanner (AI): Take a photo or pick from library; Core ML + Vision classifies the image and shows contextual info.
- 🗺️ Explore and learn: Starter screens for Featured and Nearby exploration flows.
- 🏆 Gamified learning: Badge system across themes (Colonial Heritage, Modern Marvel, Hawker Pro, and more).
- 👤 Profile & progress: Level, stats, and overall completion.
- ⚙️ Settings: Dark mode, language preferences, and notification toggles.

## What it does

- Landmark scanner (AI): Take a photo or pick from the library; Core ML + Vision classifies the image and shows contextual info.
- Explore and learn: Starter screens for Featured and Nearby exploration flows.
- Gamified learning: Badge system tracks progress across themes (e.g., Colonial Heritage, Modern Marvel, Hawker Pro).
- Profile & progress: See level, stats, and overall completion.
- Settings: Dark mode, language preferences, and notification toggles.

## Tech stack

- SwiftUI for UI and navigation (TabView, NavigationView)
- Vision + Core ML for on‑device image classification (model: `Recognition.mlmodel`)
- UIKit bridge for image capture/library (`UIImagePickerController`)
- Supabase (planned/early integration)

## App structure (key files)

- `AppDelegate.swift` — App entry point that hosts `ContentView`.
- `ContentView.swift` — Simple demo login screen that navigates to the main tab bar when “authenticated”.
- `NavigationTab.swift` — Tab bar with Home, Explore, Badges, Profile, and Settings.
- `HomepageView.swift` — Landing page with quick links and a scanner card.
- `CoremlView.swift` — Main scanner UI (pick/take photo, run prediction, show result and info text).
- `ViewModel.swift` — `CoremlViewModel` that loads the Core ML model and performs predictions via Vision.
- `ImagePicker.swift` — SwiftUI wrapper around `UIImagePickerController`.
- `BadgesView.swift` — Badge grid with per‑badge progress and completion states.
- `ProfileView.swift` — Basic profile header, level, and navigation to achievements/badges.
- `SettingsView.swift` — Appearance, language, notifications, and housekeeping actions.
- `AccountData.swift` — App constants for progress/badges and info snippets for recognized items.
- `Supabase.swift` — Supabase client initialization (see Security note below).
- `Recognition.mlmodel` — Core ML classification model packaged in the app.

## How the scanner works (high‑level)

1. User selects/takes a photo in `CoremlView` via `ImagePicker`.
2. `CoremlViewModel` resizes the image (360×360), creates a Vision request with `Recognition.mlmodel`, and runs classification.
3. The top class label is formatted and displayed. `CoremlView` maps known labels to friendly descriptions.

### Architecture (visual)

```mermaid
flowchart TD
	A[SwiftUI Views (CoremlView, Homepage, Badges, Profile, Settings)]
	B[ViewModel (CoremlViewModel)]
	C[Vision VNCoreMLRequest]
	D[Core ML: Recognition.mlmodel]
	E[UIKit Image Picker]
	F[(Supabase Client)]

	A --> B
	B --> C
	C --> D
	B --> E
	B -. planned .-> F
```

## Getting started

Prerequisites

- macOS with Xcode (recommended Xcode 15 or newer). The project uses modern SwiftUI previews (`#Preview`) that target recent SDKs.
- iOS Simulator or an iOS device.

Run

1. Clone the repository.
2. Open `SG60 Heritage Lens The Swifties.xcodeproj` in Xcode.
3. Select an iOS Simulator (or a provisioned device).
4. Build and run.

Demo login

- The current demo uses hard‑coded credentials in `ContentView.swift`:
	- Email: `user@example.com`
	- Password: `password123`
- On success, you’ll be taken to the main tab interface.

Permissions you must add (Info.plist)

If your target doesn’t already include them, add the following usage descriptions for camera/photo access:

- `NSCameraUsageDescription` — e.g., “Camera access is required to scan landmarks.”
- `NSPhotoLibraryUsageDescription` — e.g., “Photo library access is required to select images for recognition.”
- (Optional) `NSPhotoLibraryAddUsageDescription` — if you later save images back to the library.

| Key | Why it’s needed |
| --- | --- |
| NSCameraUsageDescription | Access device camera to scan landmarks |
| NSPhotoLibraryUsageDescription | Pick photos from library for recognition |
| NSPhotoLibraryAddUsageDescription (optional) | Save edited images back to the library |

## Configuration

Supabase

- File: `SG60 Heritage Lens The Swifties/Supabase.swift`
- Replace the placeholder URL/key with your own project values from Supabase.
- Security note: Never commit service role keys. Prefer storing secrets outside source control (e.g., `.xcconfig` files, build settings, or remote configuration). The current repo contains a public anon key for development only.

Authentication

- The app currently uses a demo login in `ContentView.swift`. For production, integrate Supabase Auth (email/password, OAuth, or OTP) and remove hard‑coded credentials.

Localization

- `SettingsView` offers language pickers (English/Chinese/Malay/Tamil/Singlish beta). Wire these to a localization system (e.g., `.strings` files) to translate UI and content.

## Contributing

Contributions are welcome!

- Fork the repo and create a feature branch.
- Keep changes focused and include a clear description and screenshots/video when UI changes.
- Where possible, include small unit/UI tests.
- Open a Pull Request.

Good first issues (ideas)

- Replace demo login with Supabase Auth and user profiles.
- Fill out the Explore views (Featured/Nearby) and add map/location support.
- Persist badge progress and user stats.
- Improve result text and add richer content (links, images, “then & now” comparisons).
- Add localization and accessibility passes.
- Move Supabase keys to a safer configuration path.

## Roadmap (non‑exhaustive)

- Real auth + profiles synced via Supabase
- Explorer with map and proximity alerts
- Badge achievements, sharing, and leaderboards
- Offline model updates and on‑device improvements
- Full localization (EN/ZH/MS/TA + Singlish easter eggs)

## Troubleshooting

- Build fails about permissions: ensure the Info.plist usage keys above are present.
- Camera not working in Simulator: use a real device, or test via photo library.
- Model crashes or no predictions: verify `Recognition.mlmodel` is included in the target and that the image is resized to 360×360 (as in the code).

## License

No explicit license is included. By default, all rights reserved. Consider adding a LICENSE file (e.g., MIT/Apache‑2.0) if you want broader community use.

## Acknowledgements

- Thanks to the competition organizers and contributors.
- Built with SwiftUI, Vision, Core ML, and Supabase.

