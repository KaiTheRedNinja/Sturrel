//
//  MainView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 22/10/23.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var searchManager: SearchManager = .shared

    var body: some View {
        NavigationStack {
            VStack {
                if !searchManager.showSearch {
                    FolderListView(folderID: Root.id)
                } else {
                    List {
                        if searchManager.searchText.isEmpty {
                            HStack {
                                Spacer()
                                Text("Search a Word, Lesson or Year Level")
                                Spacer()
                            }
                            .foregroundStyle(Color.gray)
                            .font(.subheadline)
                            .listRowBackground(Color.clear)
                        } else {
                            HierarchicalSearchResultView(
                                folderID: Root.id
                            )
                            .environmentObject(searchManager)
                        }
                    }
                    .safeAreaInset(edge: .top) {
                        HStack {
                            ForEach(SearchToken.allCases) { token in
                                if searchManager.searchTokens.contains(token) {
                                    Button(token.rawValue) {
                                        searchManager.searchTokens.remove(token)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .cornerRadius(15)
                                } else {
                                    Button(token.rawValue) {
                                        searchManager.searchTokens.insert(token)
                                    }
                                    .buttonStyle(.bordered)
                                    .cornerRadius(15)
                                }
                            }
                            Spacer()
                            Button {
                                // toggle between hierarchy and not
                                searchManager.showFlat.toggle()
                            } label: {
                                Image(systemName: "list.bullet" + (searchManager.showFlat ? "" : ".indent"))
                            }
                            .buttonStyle(.bordered)
                            .cornerRadius(15)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .font(.footnote)
                        .background(.regularMaterial)
                        .overlay(alignment: .bottom) {
                            VStack {
                                Divider()
                            }
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .searchable(
                text: $searchManager.searchText,
                isPresented: $searchManager.showSearch
            )
        }
    }
}

#Preview {
    MainView()
}
