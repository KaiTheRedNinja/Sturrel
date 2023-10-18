//
//  YearLevelDetailView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import SwiftUI

struct LessonsListView: View {
    var lesson: Lesson

    var body: some View {
        List {
            ForEach(lesson.vocab, id: \.hashValue) { vocab in
                NavigationLink(value: vocab) {
                    Text(vocab.word)
                }
            }
        }
        .navigationTitle(lesson.name)
        .navigationDestination(for: Vocab.self) { vocab in
            List {
                Section {
                    HStack {
                        Spacer()
                        Text(vocab.word)
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
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
}
