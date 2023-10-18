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
                    HStack {
                        Text(vocab.word)
                        Spacer()
                        Text(vocab.word.toPinyin())
                            .foregroundStyle(Color.gray)
                    }
                }
            }
        }
        .navigationTitle(lesson.name)
    }
}
