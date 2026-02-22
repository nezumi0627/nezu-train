//
//  SettingsView.swift
//  nezu-train
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("aviationstack_api_key") private var aviationstackKey = ""
    @AppStorage("odpt_api_key") private var odptKey = ""
    @AppStorage("use_biometrics") private var useBiometrics = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("API 設定"), footer: Text("Aviationstackは飛行機のリアルタイム情報取得に、ODPTはバス・新幹線の情報取得に使用されます。")) {
                    SecureField("Aviationstack API Key", text: $aviationstackKey)
                    SecureField("ODPT API Key", text: $odptKey)
                }
                
                Section(header: Text("アプリ設定")) {
                    Toggle("生体認証を使用", isOn: $useBiometrics)
                    
                    NavigationLink("データキャッシュ管理") {
                        List {
                            Text("GTFS キャッシュ (24.5 MB)")
                            Button("キャッシュをクリア", role: .destructive) { }
                        }
                        .navigationTitle("キャッシュ管理")
                    }
                }
                
                Section(header: Text("このアプリについて")) {
                    HStack {
                        Text("バージョン")
                        Spacer()
                        Text("1.1.0 (Build 12)")
                            .foregroundStyle(.secondary)
                    }
                    
                    Link(destination: URL(string: "https://github.com/nezumi0627/nezu-train")!) {
                        Label("GitHub リポジトリ", systemImage: "link")
                    }
                }
            }
            .navigationTitle("設定")
        }
    }
}

#Preview {
    SettingsView()
}
