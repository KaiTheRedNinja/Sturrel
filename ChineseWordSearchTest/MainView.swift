//
//  MainView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 22/10/23.
//

import SwiftUI

struct MainView: View {

    @ObservedObject var manager: VocabDataManager = .shared

    @State var expansionState: [String: Bool] = [:]

    @State var searchText: String = ""
    @State var showSearch: Bool = false


    var body: some View {
        NavigationStack {
            VStack {
                if !showSearch {
                    FolderListView(folder: $manager.root, isTopLevel: true)
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
                                folder: $manager.root
                            )
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .searchable(text: $searchText, isPresented: $showSearch)
            .onChange(of: manager.root) { _, _ in
                manager.reconcileVocabConfigurationToRoot()
                manager.saveRoot()
            }
        }
        .onAppear {
            manager.loadFromVocabConfiguration()
        }
    }
}

#Preview {
    MainView()
}
