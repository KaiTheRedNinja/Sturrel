//
//  FolderDetailView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import SwiftUI

struct FolderListView: View {
    @Binding var folder: VocabFolder

    var isTopLevel: Bool = false

    var body: some View {
        List {
            if !folder.subfolders.isEmpty {
                folderSection
            }

            if !folder.vocab.isEmpty && !isTopLevel {
                vocabSection
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Section {
                        Button("New Folder") {
                            newFolder()
                        }
                        if isTopLevel {
                            Button("Copy Built-in Folder") {
                                copyBuiltInFolder()
                            }
                        }
                    }
                    if !isTopLevel {
                        Section {
                            Button("New Vocab") {
                                newVocab()
                            }
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
        }
        .navigationTitle(folder.name)
    }

    var folderSection: some View {
        Section("Folders") {
            ForEach($folder.subfolders, id: \.hashValue) { $folder in
                viewForFolder($folder)
            }
            .onMove { indices, newOffset in
                folder.subfolders.move(fromOffsets: indices, toOffset: newOffset)
            }
            .onDelete { indexSet in
                folder.subfolders.remove(atOffsets: indexSet)
            }
        }
    }

    var vocabSection: some View {
        Section("Vocab") {
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
    }

    func viewForFolder(_ folder: Binding<VocabFolder>) -> some View {
        NavigationLink {
            FolderListView(folder: $folder)
        } label: {
            HStack {
                Image(systemName: "folder")
                    .frame(width: 26, height: 22)
                    .foregroundStyle(Color.accentColor)
                Text(folder.wrappedValue.name)
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

    func newFolder() {
        var name = "New Folder"
        if folder.subfolders.contains(where: { $0.name == name }) {
            var counter = 2
            while folder.subfolders.contains(where: { $0.name == "\(name) \(counter)" }) {
                counter += 1
            }
            name += " \(counter)"
        }
        folder.subfolders.append(.init(name: name, subfolders: [], vocab: []))
    }

    func copyBuiltInFolder() {
        // TODO: show a sheet for this
    }

    func newVocab() {
        // TODO: Add new vocab
    }
}
