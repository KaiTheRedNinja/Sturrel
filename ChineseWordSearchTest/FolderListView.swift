//
//  FolderDetailView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import SwiftUI

struct FolderListView: View {
    var folder: VocabFolder

    var body: some View {
        List {
            ForEach(folder.subfolders, id: \.hashValue) { folder in
                NavigationLink(value: folder) {
                    HStack {
                        Image(systemName: "folder")
                            .frame(width: 26, height: 22)
                            .foregroundStyle(Color.accentColor)
                        Text(folder.name)
                    }
                }
            }
            ForEach(folder.vocab, id: \.hashValue) { vocab in
                NavigationLink(value: vocab) {
                    HStack {
                        Text(vocab.word)
                        Spacer()
                        Text(vocab.word.toPinyin())
                            .foregroundStyle(Color.gray)
                    }
                }
            }
        }
        .navigationTitle(folder.name)
    }
}
