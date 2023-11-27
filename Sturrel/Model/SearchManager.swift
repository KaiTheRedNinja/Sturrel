//
//  SearchManager.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 23/10/23.
//

import SwiftUI

class SearchManager: ObservableObject {
    static let shared = SearchManager()

    private init() {}

    @Published var searchTokens: Set<SearchToken> = .init([.folders, .vocab])
    @Published var searchText: String = ""
    @Published var showFlat: Bool = false

    func folderContainsCriteria(_ folderID: VocabFolder.ID) -> Bool {
        guard let folder = FoldersDataManager.shared.getFolder(for: folderID) else { return false }

        // check if folder itself satisfies requirements
        if folderMatchesCriteria(folderID) {
            return true
        }

        // check if subfolders satisfy requirements
        if folder.subfolders.contains(where: { folderContainsCriteria($0) }) {
            return true
        }

        // check if vocab satisfies requirements
        if folder.vocab.contains(where: { vocabMatchesCriteria($0) }) {
            return true
        }

        return false
    }

    func folderMatchesCriteria(_ folderID: VocabFolder.ID) -> Bool {
        let lowerterm = searchText.lowercased()
        if let folder = FoldersDataManager.shared.getFolder(for: folderID),
           searchTokens.contains(.folders),
           folder.name.lowercased().contains(lowerterm) {
            return true
        }
        return false
    }

    func vocabMatchesCriteria(_ vocabID: Vocab.ID) -> Bool {
        guard searchTokens.contains(.vocab),
              let vocab = VocabDataManager.shared.getVocab(for: vocabID)
        else {
            return false
        }

        let lowerterm = searchText.lowercased()
        let word = vocab.word.lowercased()
        let pinyin = vocab.word.toPinyin(indicateTone: false)
        return word.contains(lowerterm) || pinyin.contains(lowerterm)
    }

    func highlightFor(folder: VocabFolder) -> String {
        if searchTokens.contains(.folders) {
            return searchText
        } else {
            return ""
        }
    }

    func highlightFor(vocab: Vocab) -> String {
        if searchTokens.contains(.vocab) {
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
