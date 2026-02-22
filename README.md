# nezu-train

GitHub Actions で署名無し IPA を自動ビルドし、iOS 26 の **Liquid Glass** デザインを採用した、飛行機・バス・新幹線に特化した乗り換え案内アプリ。

## 📖 プロジェクト構造

```
nezu-train/
├── README.md                   ← このファイル
├── .github/
│   └── workflows/
│       └── build-unsigned-ipa.yml   ← CI/CD（バージョン変更時のみビルド）
├── test-app/
│   └── nezu-train/
│       ├── App.swift            ← アプリエントリポイント (NezuApp)
│       ├── ContentView.swift    ← メイン画面 (TabView + HomeView)
│       ├── InfoView.swift       ← 開発者情報画面
│       ├── UpdateCheckView.swift← OTA 更新チェック画面 (UpdateView)
│       ├── VersionManager.swift ← GitHub Releases API バージョン比較 & SideStore 連携
│       ├── Info.plist           ← アプリメタデータ (v2.0.0)
│       └── Assets.xcassets/     ← アセットカタログ
├── docs/
│   ├── .nojekyll               ← Jekyll 無効化
│   ├── index.html              ← → download.html へリダイレクト
│   ├── download.html           ← IPA ダウンロードページ
│   ├── README.md               ← ドキュメント目次
│   ├── build-process.md        ← ビルド & 配布プロセス
│   ├── update-mechanism.md     ← OTA 更新機構
│   ├── design-guide.md         ← Liquid Glass デザインガイド
│   └── en/                     ← English documentation
└── pages/
    └── index.html              ← (旧) ダウンロードページ
```

## ✨ 機能

| 機能                       | 説明                                                |
| -------------------------- | --------------------------------------------------- |
| **Liquid Glass UI**        | iOS 26 正式 `.glassEffect(in:)` API を使用          |
| **OTA 更新**               | GitHub Releases から最新バージョンを自動チェック    |
| **リポジトリソース**       | **apps.json** を SideStore 等に登録して自動更新可能 |
| **インストーラー連携**     | **SideStore / AltStore** をアプリ内から直接起動     |
| **自動ビルド**             | `Info.plist` のバージョン変更時のみ CI ビルド実行   |
| **IPA ダウンロードページ** | `docs/download.html` で Web からも DL 可能          |

## 🏗️ アーキテクチャ

### Swift ファイル構成

| ファイル                | 役割                                                            |
| ----------------------- | --------------------------------------------------------------- |
| `App.swift`             | `@main` エントリポイント。`WindowGroup` で `ContentView` を起動 |
| `ContentView.swift`     | `TabView` で 3 画面を管理: ホーム / 更新 / 情報                 |
| `InfoView.swift`        | 開発者プロフィール、SNS リンク                                  |
| `UpdateCheckView.swift` | `VersionManager` を使った更新チェック UI                        |
| `VersionManager.swift`  | GitHub API 通信、セマンティックバージョン比較、SideStore 連携   |

### iOS 26 Liquid Glass の使い方

```swift
// 基本的な使い方 — ビューにガラス効果を適用
Text("Hello")
    .padding()
    .glassEffect(in: .rect(cornerRadius: 16))

// インタラクティブなガラス効果（タッチで反応）
// .regular (variant) に対して .interactive() を呼び出します
Link("Link") { }
    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 14))

// グラスボタンスタイル
Button("Action") { }
    .buttonStyle(.glass)
```

## 🚀 クイックスタート

### ビルド & リリース

1. `test-app/nezu-train/Info.plist` のバージョンまたはビルド番号を変更
   ```xml
   <key>CFBundleVersion</key>
   <string>8</string>  <!-- ← 変更 -->
   ```
2. `main` ブランチにプッシュ
3. GitHub Actions が変更を検知 → 自動ビルド
4. **Releases** タブで Draft を公開
5. アプリ内の「更新」タブから **SideStore** を経由してインストール

### ダウンロードページ

IPA は [GitHub Pages](https://nezumi0627.github.io/nezu-train/) からもダウンロード可能です。

## 📚 ドキュメント

詳細は [`docs/`](./docs/README.md) を参照:

- **[ビルドプロセス](./docs/build-process.md)** — CI/CD パイプライン、バージョン検知
- **[OTA 更新](./docs/update-mechanism.md)** — VersionManager の仕組み
- **[デザインガイド](./docs/design-guide.md)** — Liquid Glass 実装ガイド
