//
//  SearchResultView.swift
//  Sturrel
//
//  Created by Kai Quan Tay on 28/11/23.
//

import SwiftUI
import SturrelTypes
import SturrelVocab
import SturrelQuiz
import SturrelSearch
import SturrelThemesUI

let loadQueue = DispatchQueue(label: "sturrel.loadQueue")

public struct SearchResultView: View {
    @EnvironmentObject var searchManager: SearchManager
    @ObservedObject var folderDataManager: FoldersDataManager = .shared
    @ObservedObject var vocabDataManager: VocabDataManager = .shared

    @State var results: [SearchResult] = []

    public init() {}

    public var body: some View {
        ThemedList {
            ForEach(results) { result in
                switch result.result {
                case .folder(let folderID):
                    if let folder = folderDataManager.getFolder(for: folderID) {
                        NavigationLink(value: FolderOrVocabID.folder(folderID)) {
                            HStack {
                                Image(systemName: "folder")
                                    .frame(width: 26, height: 22)
                                    .foregroundStyle(Color.accentColor)
                                Text(folder.name)
                            }
                        }
                    }
                case .vocab(let vocabID):
                    if let vocab = vocabDataManager.getVocab(for: vocabID) {
                        NavigationLink(value: FolderOrVocabID.vocab(vocabID)) {
                            HStack {
                                if vocab.isHCL {
                                    Image(systemName: "staroflife.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 14)
                                }
                                Text(vocab.word)
                                Spacer()
                                Text(vocab.word.toPinyin())
                                    .foregroundStyle(Color.additional)
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: "\(searchManager.searchText) \(searchManager.searchTokens)") { _ in
            loadQueue.async {
                let results = searchManager.searchResults()
                DispatchQueue.main.async {
                    self.results = results
                }
            }
        }
    }
}
