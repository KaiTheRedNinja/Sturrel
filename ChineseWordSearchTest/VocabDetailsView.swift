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

    var editMode: EditMode {
        rawEditMode?.wrappedValue ?? .inactive
    }

    var body: some View {
        Section {
            HStack {
                Spacer()
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
                Spacer()
            }
            .listRowBackground(Color.clear)
        }

        if !vocab.definition.isEmpty {
            Section("Definition") {
                Text(vocab.definition)
            }
        }

        if !vocab.sentences.isEmpty {
            Section("Example Sentences") {
                ForEach(Array(vocab.sentences.enumerated()), id: \.offset) { (_, sentence) in
                    Text(sentence)
                }
            }
        }

        if !vocab.wordBuilding.isEmpty {
            Section("Example Words") {
                ForEach(Array(vocab.wordBuilding.enumerated()), id: \.offset) { (_, wordBuilding) in
                    Text(wordBuilding)
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
                        if editMode == .inactive {
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
