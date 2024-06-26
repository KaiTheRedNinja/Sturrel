//
//  SearchManager.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 23/10/23.
//

import SwiftUI
import SturrelTypes
import SturrelVocab
import PinYin

public class SearchManager: ObservableObject {
    public static let shared = SearchManager()

    private init() {}

    @Published public var searchTokens: Set<SearchToken> = .init([.folders, .vocab])
    @Published public var searchText: String = ""
    @Published public var showFlat: Bool = false

    public func searchResults() -> [SearchResult] {
        guard !searchText.isEmpty else { return [] }
        return searchResultsWithin(folderID: Root.id, for: searchText.lowercased())
    }

    public func searchResultsWithin(folderID: VocabFolder.ID, for search: String) -> [SearchResult] {
        guard let folder = FoldersDataManager.shared.getFolder(for: folderID) else { return [] }
        var results: [SearchResult] = []

        // check if the folder itself matches
//        if matchesCriteria(folder: folder, search: search) {
//            results.append(.init(steps: [], result: .folder(folder.id)))
//        }

        // check the vocabs
        for vocabID in folder.vocab where matchesCriteria(vocabID: vocabID, search: search) {
            results.append(.init(steps: [], result: .vocab(vocabID)))
        }

        // check the folders
        for subfolder in folder.subfolders {
            let subfolderResults = searchResultsWithin(folderID: subfolder, for: search)
            results.append(contentsOf: subfolderResults.map({ $0.adding(parent: subfolder) }))
        }

        return results
    }

    private func matchesCriteria(folder: VocabFolder, search: String) -> Bool {
       return searchTokens.contains(.folders) && folder.name.lowercased().contains(search)
    }

    private func matchesCriteria(vocabID: Vocab.ID, search: String) -> Bool {
        guard searchTokens.contains(.vocab),
              let vocab = VocabDataManager.shared.getVocab(for: vocabID)
        else {
            return false
        }

        let word = vocab.word.lowercased()
        let pinyin = vocab.word.toPinyin(indicateTone: false)
        return word.contains(search) || pinyin.contains(search)
    }
}
