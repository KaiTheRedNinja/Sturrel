//
//  HierarchicalSearchResultView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 19/10/23.
//

import SwiftUI

struct HierarchicalSearchResultView: View {
    var searchText: String
    var folder: Binding<VocabFolder>

    var body: some View {
        ForEach(folder.subfolders, id: \.hashValue) { $subFolder in
            if folderContainsSearch(folder: subFolder, term: searchText) {
                NavigationLink {
                    FolderListView(folder: $subFolder)
                } label: {
                    HStack {
                        Image(systemName: "folder")
                            .frame(width: 26, height: 22)
                            .foregroundStyle(Color.accentColor)
                        HighlightedText(.init(subFolder.name), highlight: searchText)
                    }
                }
                HierarchicalSearchResultView(
                    searchText: searchText,
                    folder: $subFolder
                )
                .padding(.leading, 16)
            }
        }
        ForEach(folder.vocab, id: \.hashValue) { $vocab in
            if vocab.word.lowercased().contains(searchText.lowercased()) {
                NavigationLink(value: vocab) {
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

    func folderContainsSearch(folder: VocabFolder, term: String) -> Bool {
        let lowerterm = term.lowercased()
        if folder.name.lowercased().contains(lowerterm) { return true }
        if folder.subfolders.contains(where: {
            folderContainsSearch(folder: $0, term: term)
        }) {
            return true
        }
        if folder.vocab.contains(where: {
            $0.word.lowercased().contains(lowerterm)
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
