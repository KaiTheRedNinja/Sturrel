//
//  SearchResultView.swift
//  Sturrel
//
//  Created by Kai Quan Tay on 28/11/23.
//

import SwiftUI

let loadQueue = DispatchQueue(label: "sturrel.loadQueue")

struct SearchResultView: View {
    @EnvironmentObject var searchManager: SearchManager
    @ObservedObject var folderDataManager: FoldersDataManager = .shared
    @ObservedObject var vocabDataManager: VocabDataManager = .shared

    @State var results: [SearchResult] = []

    var body: some View {
        List {
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
                                    .foregroundStyle(Color.gray)
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: "\(searchManager.searchText) \(searchManager.searchTokens)") { _, _ in
            loadQueue.async {
                let results = searchManager.searchResults()
                DispatchQueue.main.async {
                    self.results = results
                }
            }
        }
    }
}
