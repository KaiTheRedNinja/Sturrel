//
//  ContentView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Vocab", systemImage: "character.book.closed.fill.zh")
                }
            NavigationStack {
                List {
                    Section {
                        ForEach(0..<5) { index in
                            Text("Setting \(index)")
                        }
                    }

                    Section {
                        HStack {
                            Spacer()
                            VStack {
                                Text("Vocabulary provided by\nXueLin Learning Hub")
                                    .multilineTextAlignment(.center)
                                Image("xuelinLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                            }
                            Spacer()
                        }
                        .foregroundStyle(Color.gray)
                        .listRowBackground(Color.clear)
                    }
                }
                .navigationTitle("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}

#Preview {
    ContentView()
}
