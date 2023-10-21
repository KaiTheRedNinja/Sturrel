//
//  VocabDetailsView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import SwiftUI

struct VocabDetailsView: View {
    @Binding var vocab: Vocab

    var body: some View {
        List {
            VocabDetailsContentsView(vocab: $vocab)
        }
        .navigationTitle("Vocab")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditButton()
        }
    }
}

private struct VocabDetailsContentsView: View {
    @Binding var vocab: Vocab

    @Environment(\.editMode) var rawEditMode

    var isEditing: Bool {
        rawEditMode?.wrappedValue.isEditing ?? false
    }

    var body: some View {
        Section {
            HStack {
                Spacer()
                if isEditing {
                    VStack {
                        let pinyin = vocab.word.toPinyin()
                        TextField("", text: $vocab.word)
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
        }

        if !vocab.definition.isEmpty || isEditing {
            Section("Definition") {
                if isEditing {
                    TextField("", text: $vocab.definition)
                } else {
                    Text(vocab.definition)
                }
            }
        }

        if !vocab.sentences.isEmpty || isEditing {
            Section("Example Sentences") {
                ForEach(Array(vocab.sentences.enumerated()), id: \.offset) { (_, sentence) in
                    Text(sentence)
                }
                .onMove { indices, newOffset in
                    vocab.sentences.move(fromOffsets: indices, toOffset: newOffset)
                }
                .onDelete { indexSet in
                    vocab.sentences.remove(atOffsets: indexSet)
                }

                HStack {
                    Spacer()
                    Button {
                        vocab.sentences.append("New Sentence")
                    } label: {
                        Image(systemName: "plus")
                    }
                    Spacer()
                }
            }
        }

        if !vocab.wordBuilding.isEmpty || isEditing {
            Section("Example Words") {
                ForEach(Array(vocab.wordBuilding.enumerated()), id: \.offset) { (_, wordBuilding) in
                    Text(wordBuilding)
                }
                .onMove { indices, newOffset in
                    vocab.wordBuilding.move(fromOffsets: indices, toOffset: newOffset)
                }
                .onDelete { indexSet in
                    vocab.wordBuilding.remove(atOffsets: indexSet)
                }

                HStack {
                    Spacer()
                    Button {
                        vocab.wordBuilding.append("New Phrase")
                    } label: {
                        Image(systemName: "plus")
                    }
                    Spacer()
                }
            }
        }

        if vocab.definition.isEmpty || vocab.sentences.isEmpty || vocab.wordBuilding.isEmpty {
            Section {
                HStack {
                    Spacer()
                    VStack {
                        if vocab.definition.isEmpty || vocab.sentences.isEmpty || vocab.wordBuilding.isEmpty {
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
