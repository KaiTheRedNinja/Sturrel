//
//  MainView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 22/10/23.
//

import SwiftUI

class SearchManager: ObservableObject {
    @Published var searchTokens: [SearchToken] = []
    @Published var searchText: String = ""
    @Published var showSearch: Bool = false

    func folderMatchesCriteria(_ folderID: VocabFolder.ID) -> Bool {
        let lowerterm = searchText.lowercased()
        guard let folder = FoldersDataManager.shared.getFolder(for: folderID) else { return false }

        // check if folder itself satisfies requirements
        if (searchTokens.isEmpty || searchTokens.contains(.folders)),
           folder.name.lowercased().contains(lowerterm) {
            return true
        }

        // check if subfolders satisfy requirements
        if folder.subfolders.contains(where: { folderMatchesCriteria($0) }) {
            return true
        }

        // check if vocab satisfies requirements
        if folder.vocab.contains(where: { vocabMatchesCriteria($0) }) {
            return true
        }

        return false
    }

    func vocabMatchesCriteria(_ vocabID: Vocab.ID) -> Bool {
        guard (searchTokens.isEmpty || searchTokens.contains(.vocab)),
              let vocab = VocabDataManager.shared.getVocab(for: vocabID)
        else {
            return false
        }

        let lowerterm = searchText.lowercased()
        return vocab.word.lowercased().contains(lowerterm)
    }

    func highlightFor(folder: VocabFolder) -> String {
        if (searchTokens.isEmpty || searchTokens.contains(.folders)) {
            return searchText
        } else {
            return ""
        }
    }

    func highlightFor(vocab: Vocab) -> String {
        if (searchTokens.isEmpty || searchTokens.contains(.vocab)) {
            return searchText
        } else {
            return ""
        }
    }
}

enum SearchToken: String, Identifiable, CaseIterable {
    var id: String { rawValue }

    case folders = "Folders"
    case vocab = "Vocab"
}

struct MainView: View {

    @ObservedObject var searchManager: SearchManager = .init()

    var body: some View {
        NavigationStack {
            VStack {
                if !searchManager.showSearch {
                    FolderListView(folderID: Root.id)
                } else {
                    List {
                        Section {
                            ForEach(SearchToken.allCases) { token in
                                if !searchManager.searchTokens.contains(token) {
                                    Button {
                                        searchManager.searchTokens.append(token)
                                    } label: {
                                        Label(token.rawValue, systemImage: "line.3.horizontal.decrease.circle")
                                    }
                                    .foregroundStyle(Color.accentColor)
                                }
                            }
                        }

                        Section {
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
                    }
                }
            }
            .listStyle(.sidebar)
            .searchable(
                text: $searchManager.searchText,
                tokens: $searchManager.searchTokens,
                isPresented: $searchManager.showSearch
            ) { token in
                Text(token.rawValue)
            }
        }
    }
}

#Preview {
    MainView()
}
