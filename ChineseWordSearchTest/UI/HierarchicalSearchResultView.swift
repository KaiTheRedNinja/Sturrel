//
//  HierarchicalSearchResultView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 19/10/23.
//

import SwiftUI

struct HierarchicalSearchResultView: View {
    var searchText: String
    var folderID: VocabFolder.ID

    var body: some View {
        if let folder = FoldersDataManager.shared.getFolder(for: folderID) {
            folderContent(for: folder)
        } else {
            Text("Internal Error")
        }
    }

    @ViewBuilder
    func folderContent(for folder: VocabFolder) -> some View {
        ForEach(folder.subfolders, id: \.hashValue) { subFolderID in
            if folderContainsSearch(folderID: subFolderID, term: searchText) {
                NavigationLink {
                    FolderListView(folderID: subFolderID)
                } label: {
                    HStack {
                        Image(systemName: "folder")
                            .frame(width: 26, height: 22)
                            .foregroundStyle(Color.accentColor)
                        if let subFolder = FoldersDataManager.shared.getFolder(for: subFolderID) {
                            HighlightedText(.init(subFolder.name), highlight: searchText)
                        }
                    }
                }
                HierarchicalSearchResultView(
                    searchText: searchText,
                    folderID: subFolderID
                )
                .padding(.leading, 16)
            }
        }
        ForEach(folder.vocab, id: \.hashValue) { vocabID in
            if let vocab = VocabDataManager.shared.getVocab(for: vocabID),
               vocab.word.lowercased().contains(searchText.lowercased()) {
                NavigationLink {
                    VocabDetailsView(vocabID: vocabID)
                } label: {
                    HStack {
                        HighlightedText(.init(vocab.word), highlight: searchText)
                        Spacer()
                        Text(vocab.word.toPinyin())
                            .foregroundStyle(Color.gray)
                    }
                }
            }
        }
    }

    func folderContainsSearch(folderID: VocabFolder.ID, term: String) -> Bool {
        let lowerterm = term.lowercased()
        guard let folder = FoldersDataManager.shared.getFolder(for: folderID) else { return false }
        if folder.name.lowercased().contains(lowerterm) { return true }
        if folder.subfolders.contains(where: {
            folderContainsSearch(folderID: $0, term: term)
        }) {
            return true
        }
        if folder.vocab.contains(where: { vocabID in
            guard let vocab = VocabDataManager.shared.getVocab(for: vocabID) else { return false }
            return vocab.word.lowercased().contains(lowerterm)
        }) {
            return true
        }
        return false
    }
}

struct HighlightedText: View {
    private let attributed: AttributedString

    init(_ text: AttributedString, highlight: String) {
        var attributed = text
        if let highlightRange = attributed.range(of: highlight, options: .caseInsensitive) {
            attributed[highlightRange].backgroundColor = Color.accentColor.opacity(0.2)
        }
        self.attributed = attributed
    }

    var body: some View {
        Text(attributed)
    }
}
