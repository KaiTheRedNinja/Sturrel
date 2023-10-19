//
//  ContentView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager: VocabDataManager = .init()

    @State var expansionState: [String: Bool] = [:]

    @State var searchText: String = ""
    @State var showSearch: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                if !showSearch {
                    FolderListView(folder: manager.root)
                } else {
                    if searchText.isEmpty {
                        HStack {
                            Spacer()
                            Text("Search a Word, Lesson or Year Level")
                            Spacer()
                        }
                        .foregroundStyle(Color.gray)
                        .font(.subheadline)
                        .listRowBackground(Color.clear)
                    } else {
                        List {
                            HierarchicalSearchResultView(
                                searchText: searchText,
                                folder: manager.root
                            )
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationDestination(for: VocabFolder.self) { folder in
                FolderListView(folder: folder)
            }
            .navigationDestination(for: Vocab.self) { vocab in
                VocabDetailsView(vocab: vocab)
            }
            .searchable(text: $searchText, isPresented: $showSearch)
        }
        .onAppear {
            manager.loadDefaultFolders()
        }
    }
}

#Preview {
    ContentView()
}
