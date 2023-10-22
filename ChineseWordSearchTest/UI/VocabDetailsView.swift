//
//  VocabDetailsView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import SwiftUI

struct VocabDetailsView: View {
    var vocabID: Vocab.ID

    var body: some View {
        List {
            VocabDetailsContentsView(vocabID: vocabID)
        }
        .navigationTitle("Vocab")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditButton()
        }
    }
}

private struct VocabDetailsContentsView: View {
    var vocabID: Vocab.ID

    @ObservedObject var vocabDataManager = VocabDataManager.shared

    @Environment(\.editMode) var rawEditMode

    var isEditing: Bool {
        rawEditMode?.wrappedValue.isEditing ?? false
    }

    var body: some View {
        let vocab = vocabDataManager.getVocab(for: vocabID)!
        Section(vocab.isHCL ? "HCL" : "") {
            HStack {
                Spacer()
                if isEditing {
                    VStack {
                        let pinyin = vocab.word.toPinyin()
                        TextField("", text: vocabDataManager.bindingVocab(for: vocabID).word)
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.center)
                        Text(pinyin)
                            .font(.subheadline)
                            .foregroundStyle(Color.gray)
                    }
                } else {
                    HStack {
                        let pinyin = vocab.word.toPinyin().split(separator: " ")
                        ForEach(0..<vocab.word.count, id: \.self) { index in
                            VStack(alignment: .center) {
                                let vocabIndex = vocab.word.index(vocab.word.startIndex, offsetBy: index)
                                Text(vocab.word[vocabIndex...vocabIndex])
                                    .font(.largeTitle)
                                    .bold()
                                Text(pinyin[index])
                                    .font(.subheadline)
                                    .foregroundStyle(Color.gray)
                            }
                        }
                    }
                }
                Spacer()
            }
            .listRowBackground(Color.clear)
            if isEditing {
                Toggle("Is Higher Chinese Word", isOn: vocabDataManager.bindingVocab(for: vocabID).isHCL)
                    .listRowBackground(Color.clear)
            }
        }

        if !vocab.definition.isEmpty || isEditing {
            Section("Definition") {
                if isEditing {
                    TextField("Definition", text: vocabDataManager.bindingVocab(for: vocabID).definition)
                } else {
                    Text(vocab.definition)
                }
            }
        }

        if !vocab.sentences.isEmpty || isEditing {
            Section("Example Sentences") {
                ForEach(Array(vocabDataManager.bindingVocab(for: vocabID).sentences.enumerated()), id: \.offset) { (_, $sentence) in
                    if isEditing {
                        TextField("Sentence", text: $sentence)
                    } else {
                        Text(sentence)
                    }
                }
                .onMove { indices, newOffset in
                    vocabDataManager.bindingVocab(for: vocabID).wrappedValue.sentences.move(fromOffsets: indices, toOffset: newOffset)
                }
                .onDelete { indexSet in
                    vocabDataManager.bindingVocab(for: vocabID).wrappedValue.sentences.remove(atOffsets: indexSet)
                }

                if isEditing {
                    HStack {
                        Spacer()
                        Button {
                            vocabDataManager.bindingVocab(for: vocabID).wrappedValue.sentences.append("New Sentence")
                        } label: {
                            Image(systemName: "plus")
                        }
                        Spacer()
                    }
                }
            }
        }

        if !vocab.wordBuilding.isEmpty || isEditing {
            Section("Example Words") {
                ForEach(Array(vocabDataManager.bindingVocab(for: vocabID).wordBuilding.enumerated()), id: \.offset) { (_, $wordBuilding) in
                    if isEditing {
                        TextField("Phrase", text: $wordBuilding)
                    } else {
                        Text(wordBuilding)
                    }
                }
                .onMove { indices, newOffset in
                    vocabDataManager.bindingVocab(for: vocabID).wrappedValue.wordBuilding.move(fromOffsets: indices, toOffset: newOffset)
                }
                .onDelete { indexSet in
                    vocabDataManager.bindingVocab(for: vocabID).wrappedValue.wordBuilding.remove(atOffsets: indexSet)
                }

                if isEditing {
                    HStack {
                        Spacer()
                        Button {
                            vocabDataManager.bindingVocab(for: vocabID).wrappedValue.wordBuilding.append("New Phrase")
                        } label: {
                            Image(systemName: "plus")
                        }
                        Spacer()
                    }
                }
            }
        }

        if vocab.definition.isEmpty || vocab.sentences.isEmpty || vocab.wordBuilding.isEmpty {
            Section {
                HStack {
                    Spacer()
                    VStack {
                        if vocab.definition.isEmpty && vocab.sentences.isEmpty && vocab.wordBuilding.isEmpty {
                            Text("No Details.")
                        }
                        if !isEditing {
                            if vocab.definition.isEmpty {
                                if vocab.sentences.isEmpty {
                                    Text("Press Edit to add a definition or example sentences")
                                } else if vocab.wordBuilding.isEmpty {
                                    Text("Press Edit to add a definition or example phrases")
                                } else {
                                    Text("Press Edit to add a definition, example sentences, or phrases")
                                }
                            } else { // a definition is present
                                if vocab.sentences.isEmpty {
                                    Text("Press Edit to add example sentences")
                                } else if vocab.wordBuilding.isEmpty {
                                    Text("Press Edit to add example phrases")
                                }
                                // all three being non-empty won't occur
                            }
                        }
                    }
                    .foregroundStyle(Color.gray)
                    .multilineTextAlignment(.center)
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }
        }
    }
}
