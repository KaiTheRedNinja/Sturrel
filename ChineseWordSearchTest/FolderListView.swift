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

    @State var prototypeNewFolder: VocabFolder?
    @State var prototypeNewVocab: Vocab?

    var body: some View {
        List {
            if folder.subfolders.isEmpty && folder.vocab.isEmpty {
                HStack {
                    Spacer()
                    Text("Empty Folder.\nPress + to add subfolders or vocab")
                        .foregroundStyle(Color.gray)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }

            if !folder.subfolders.isEmpty {
                folderSection
            }

            if !folder.vocab.isEmpty && !isTopLevel {
                vocabSection
            }
        }
        .toolbar {
            toolbarContent
        }
        .navigationTitle(folder.name)
        .sheet(isPresented: .init(get: {
            prototypeNewFolder != nil
        }, set: { isShown in
            if !isShown {
                prototypeNewFolder = nil
            }
        }), content: {
            NewFolderView(
                folder: $folder,
                prototypeNewFolder: $prototypeNewFolder
            )
            .interactiveDismissDisabled(true)
        })
        .sheet(isPresented: .init(get: {
            prototypeNewVocab != nil
        }, set: { isShown in
            if !isShown {
                prototypeNewVocab = nil
            }
        })) {
            NewVocabView(
                folder: $folder,
                prototypeNewVocab: $prototypeNewVocab
            )
            .interactiveDismissDisabled(true)
        }
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
            ForEach($folder.vocab, id: \.hashValue) { $vocab in
                viewForVocab($vocab)
            }
            .onMove { indices, newOffset in
                folder.vocab.move(fromOffsets: indices, toOffset: newOffset)
            }
            .onDelete { indexSet in
                folder.vocab.remove(atOffsets: indexSet)
            }
        }
    }

    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
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

    func viewForFolder(_ folder: Binding<VocabFolder>) -> some View {
        NavigationLink {
            FolderListView(folder: folder)
        } label: {
            HStack {
                Image(systemName: "folder")
                    .frame(width: 26, height: 22)
                    .foregroundStyle(Color.accentColor)
                Text(folder.wrappedValue.name)
            }
        }
    }

    func viewForVocab(_ vocab: Binding<Vocab>) -> some View {
        NavigationLink {
            VocabDetailsView(vocab: vocab)
        } label: {
            HStack {
                Text(vocab.wrappedValue.word)
                Spacer()
                Text(vocab.wrappedValue.word.toPinyin())
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
        prototypeNewFolder = .init(name: name, subfolders: [], vocab: [])
    }

    func copyBuiltInFolder() {
        // TODO: show a sheet for this
    }

    func newVocab() {
        prototypeNewVocab = .init(word: "无标题", definition: "", sentences: [], wordBuilding: [])
    }
}
