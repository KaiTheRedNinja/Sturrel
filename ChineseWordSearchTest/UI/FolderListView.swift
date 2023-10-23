//
//  FolderDetailView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import SwiftUI

struct FolderListView: View {
    var folderID: VocabFolder.ID

    var isTopLevel: Bool = false

    @State var showNewFolder: Bool = false
    @State var showNewVocab: Bool = false

    @ObservedObject var folderDataManager: FoldersDataManager = .shared
    @ObservedObject var vocabDataManager: VocabDataManager = .shared

    init(folderID: VocabFolder.ID, isTopLevel: Bool = false) {
        self.folderID = folderID
        self.isTopLevel = isTopLevel
    }

    var body: some View {
        if let folder = folderDataManager.getFolder(for: folderID) {
            folderContent(for: folder)
        } else {
            Text("Internal Error")
        }
    }

    func folderContent(for folder: VocabFolder) -> some View {
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
                folderSection(subfolders: folderDataManager.bindingFolder(for: folderID).subfolders)
            }

            if !folder.vocab.isEmpty && !isTopLevel {
                vocabSection(vocab: folderDataManager.bindingFolder(for: folderID).vocab)
            }
        }
        .toolbar {
            toolbarContent
        }
        .navigationTitle(folder.name)
        .sheet(isPresented: $showNewFolder) {
            NewFolderView(
                targetFolderID: folderID
            )
            .interactiveDismissDisabled(true)
        }
        .sheet(isPresented: $showNewVocab) {
            NewVocabView(
                targetFolderID: folderID
            )
            .interactiveDismissDisabled(true)
        }
        .onChange(of: folder) { _, newValue in
            folderDataManager.saveFolder(newValue)
        }
    }

    func folderSection(subfolders: Binding<[VocabFolder.ID]>) -> some View {
        Section("Folders") {
            ForEach(subfolders.wrappedValue, id: \.hashValue) { folder in
                viewForFolder(folder)
            }
            .onMove { indices, newOffset in
                subfolders.wrappedValue.move(fromOffsets: indices, toOffset: newOffset)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    folderDataManager.removeFolder(subfolders[index].wrappedValue)
                }
                subfolders.wrappedValue.remove(atOffsets: indexSet)
            }
        }
    }

    func vocabSection(vocab: Binding<[Vocab.ID]>) -> some View {
        Section("Vocab") {
            ForEach(vocab.wrappedValue, id: \.hashValue) { vocab in
                viewForVocab(vocab)
            }
            .onMove { indices, newOffset in
                vocab.wrappedValue.move(fromOffsets: indices, toOffset: newOffset)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    vocabDataManager.removeVocab(vocab[index].wrappedValue)
                }
                vocab.wrappedValue.remove(atOffsets: indexSet)
            }
        }
    }

    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                // TODO: games
            } label: {
                Image(systemName: "play")
            }
        }

        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Section {
                    Button("New Folder") {
                        newFolder()
                    }
                    if isTopLevel {
                        Menu("Copy Built-in Folder") {
                            ForEach(Root.builtins, id: \.self) { filename in
                                Button(filename) {
                                    Root.copyBuiltinFolder(named: filename)
                                }
                            }
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

    @ViewBuilder
    func viewForFolder(_ folderID: VocabFolder.ID) -> some View {
        if let folder = folderDataManager.getFolder(for: folderID) {
            NavigationLink {
                FolderListView(folderID: folderID)
            } label: {

                HStack {
                    Image(systemName: "folder")
                        .frame(width: 26, height: 22)
                        .foregroundStyle(Color.accentColor)
                    Text(folder.name)
                }
            }
        }
    }

    @ViewBuilder
    func viewForVocab(_ vocabID: Vocab.ID) -> some View {
        if let vocab = vocabDataManager.getVocab(for: vocabID) {
            NavigationLink {
                VocabDetailsView(vocabID: vocabID)
            } label: {
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

    func newFolder() {
        showNewFolder = true
    }

    func newVocab() {
        showNewVocab = true
    }
}
