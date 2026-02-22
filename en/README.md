# nezu-train

A simple iOS app that automatically builds unsigned IPAs using GitHub Actions and features the iOS 26 **Liquid Glass** design.

[Japanese](../README.md)

## 📖 Project Structure

```
nezu-train/
├── README.md                   ← Main README (JP)
├── .github/
│   └── workflows/
│       └── build-unsigned-ipa.yml   ← CI/CD (Builds on version change)
├── test-app/
│   └── nezu-train/
│       ├── NezuTrainApp.swift   ← App entry point (NezuTrainApp)
│       ├── ContentView.swift    ← Main screen (TabView + HomeView)
│       ├── InfoView.swift       ← Info screen
│       ├── UpdateCheckView.swift← OTA Update screen (UpdateView)
│       ├── VersionManager.swift ← GitHub Releases API & SideStore integration
│       ├── Info.plist           ← App metadata (v2.0.0)
│       └── Assets.xcassets/     ← Asset catalog
└── docs/
    ├── README.md               ← Documentation index
    ├── en/
    │   ├── build-process.md     ← Build & distribution process
    │   ├── update-mechanism.md  ← OTA update mechanism
    │   └── design-guide.md      ← Liquid Glass design guide
    └── ...
```

## ✨ Features

| Feature                   | Description                                                  |
| ------------------------- | ------------------------------------------------------------ |
| **Liquid Glass UI**       | Uses official iOS 26 `.glassEffect(in:)` API                 |
| **OTA Updates**           | Automatically checks for the latest version via GitHub       |
| **Installer Integration** | Directly launch **SideStore / AltStore** from within the app |
| **Automated Build**       | CI builds triggered only on `Info.plist` version changes     |
| **IPA Download Page**     | Web-based downloads via `docs/download.html` (GitHub Pages)  |

## 🏗️ Architecture

### Swift File Structure

| File                    | Role                                                                |
| ----------------------- | ------------------------------------------------------------------- |
| `NezuTrainApp.swift`    | `@main` entry point. Launches `ContentView`                         |
| `ContentView.swift`     | Manages 3 screens via `TabView`: Home / Update / Info               |
| `InfoView.swift`        | Developer profile and social links                                  |
| `UpdateCheckView.swift` | UI for checking updates using `VersionManager`                      |
| `VersionManager.swift`  | GitHub API communication, version comparison, SideStore integration |

### iOS 26 Liquid Glass Usage

```swift
// Basic usage — apply glass effect to a view
Text("Hello")
    .padding()
    .glassEffect(in: .rect(cornerRadius: 16))

// Interactive glass effect (responds to touch)
// Call .interactive() on the Glass variant (.regular)
Link("Link") { }
    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 14))

// Glass button style
Button("Action") { }
    .buttonStyle(.glass)
```

## 🚀 Quick Start

### Build & Release

1. Increment the version or build number in `test-app/nezu-train/Info.plist`.
   ```xml
   <key>CFBundleVersion</key>
   <string>8</string>
   ```
2. Push to the `main` branch.
3. GitHub Actions detects the change and builds automatically.
4. Publish the **Draft** in the Releases tab.
5. Go to the "Update" tab in the app and install via **SideStore**.

### Download Page

IPAs are also available for download from [GitHub Pages](https://nezumi0627.github.io/nezu-train/).

## 📚 Documentation

See [`docs/en/`](../docs/en/README.md) for details:

- **[Build Process](../docs/en/build-process.md)** — CI/CD pipeline, version detection
- **[OTA Update](../docs/en/update-mechanism.md)** — How VersionManager works
- **[Design Guide](../docs/en/design-guide.md)** — Guide for implementing Liquid Glass
