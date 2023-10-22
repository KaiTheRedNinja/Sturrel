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
                        NavigationLink {
                            ScrollView {
                                VStack(alignment: .center) {
                                    VStack {
                                        Text("Rewritten by Tay Kai Quan")
                                            .padding(.bottom, 10)
                                        Text("Originally written and designed by:\nTay Kai Quan\nNatalie Ruzsicska\nElyssa Yeo\nZara Rosman")
                                    }
                                    .padding(.bottom, 60)

                                    VStack {
                                        Text("Vocabulary provided by\nXueLin Learning Hub")
                                        Image("xuelinLogo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 100)
                                    }
                                }
                                .foregroundStyle(Color.gray)
                                .listRowBackground(Color.clear)
                                .multilineTextAlignment(.center)
                            }
                        } label: {
                            Text("Credits")
                        }
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
