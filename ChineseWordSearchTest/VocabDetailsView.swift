//
//  VocabDetailsView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import SwiftUI

struct VocabDetailsView: View {
    var vocab: Vocab

    var body: some View {
        List {
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
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
