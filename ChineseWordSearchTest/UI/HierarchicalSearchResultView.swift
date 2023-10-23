//
//  HierarchicalSearchResultView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 19/10/23.
//

import SwiftUI

struct HierarchicalSearchResultView: View {
    @EnvironmentObject var searchManager: SearchManager

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
            if searchManager.folderMatchesCriteria(subFolderID) {
                NavigationLink {
                    FolderListView(folderID: subFolderID)
                } label: {
                    HStack {
                        Image(systemName: "folder")
                            .frame(width: 26, height: 22)
                            .foregroundStyle(Color.accentColor)
                        if let subFolder = FoldersDataManager.shared.getFolder(for: subFolderID) {
                            HighlightedText(subFolder.name, highlight: searchManager.highlightFor(folder: subFolder))
                        }
                    }
                }
                HierarchicalSearchResultView(
                    folderID: subFolderID
                )
                .padding(.leading, 16)
            }
        }
        ForEach(folder.vocab, id: \.hashValue) { vocabID in
            if let vocab = VocabDataManager.shared.getVocab(for: vocabID),
               searchManager.vocabMatchesCriteria(vocabID) {
                NavigationLink {
                    VocabDetailsView(vocabID: vocabID)
                } label: {
                    HStack {
                        HighlightedText(vocab.word, highlight: searchManager.highlightFor(vocab: vocab))
                        Spacer()
                        Text(vocab.word.toPinyin())
                            .foregroundStyle(Color.gray)
                    }
                }
            }
        }
    }
}

struct HighlightedText: View {
    private let attributed: AttributedString

    init(_ text: String, highlight: String) {
        self.init(AttributedString(text), highlight: highlight)
    }

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
