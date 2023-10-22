//
//  MainView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 22/10/23.
//

import SwiftUI

enum FolderOrVocabID {
    case folder(VocabFolder.ID)
    case vocab(Vocab.ID)
}

struct MainView: View {

    @State var expansionState: [String: Bool] = [:]

    @State var searchText: String = ""
    @State var showSearch: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                if !showSearch {
                    FolderListView(folderID: Root.id)
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
                                folderID: Root.id
                            )
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .searchable(text: $searchText, isPresented: $showSearch)
        }
    }
}

#Preview {
    MainView()
}
