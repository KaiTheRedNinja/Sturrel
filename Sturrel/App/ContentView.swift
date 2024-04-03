//
//  ContentView.swift
//  Sturrel
//
//  Created by Kai Quan Tay on 27/10/23.
//

import SwiftUI
import SturrelThemes

struct ContentView: View {
    @ObservedObject var startManager: StartManager = .shared

    var body: some View {
        if startManager.shown {
            StartView()
        } else {
            tabView
        }
    }

    var tabView: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Vocab", systemImage: "character.book.closed.fill.zh")
                }
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .tint(Color.detail)
        .sheet(item: $startManager.changes) { change in
            BuiltinsUpdateView(changes: change.changes.map({ ($0, true) }))
        }
    }
}

#Preview {
    ContentView()
}
