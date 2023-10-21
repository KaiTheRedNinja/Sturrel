//
//  FolderDetailView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import SwiftUI

struct FolderListView: View {
    @Binding var folder: VocabFolder

    var body: some View {
        List {
            ForEach(folder.subfolders, id: \.hashValue) { folder in
                viewForFolder(folder)
            }
            .onMove { indices, newOffset in
                folder.subfolders.move(fromOffsets: indices, toOffset: newOffset)
            }
            .onDelete { indexSet in
                folder.subfolders.remove(atOffsets: indexSet)
            }
            ForEach(folder.vocab, id: \.hashValue) { vocab in
                viewForVocab(vocab)
            }
            .onMove { indices, newOffset in
                folder.vocab.move(fromOffsets: indices, toOffset: newOffset)
            }
            .onDelete { indexSet in
                folder.vocab.remove(atOffsets: indexSet)
            }
        }
        .toolbar {
            EditButton()
        }
        .navigationTitle(folder.name)
    }

    func viewForFolder(_ folder: VocabFolder) -> some View {
        NavigationLink(value: folder) {
            HStack {
                Image(systemName: "folder")
                    .frame(width: 26, height: 22)
                    .foregroundStyle(Color.accentColor)
                Text(folder.name)
            }
        }
    }

    func viewForVocab(_ vocab: Vocab) -> some View {
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
