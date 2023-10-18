//
//  ContentView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager: YearLevelDataManager = .init()

    @State var expansionState: [String: Bool] = [:]

    @State var searchText: String = ""
    @State var showSearch: Bool = false

    var body: some View {
        NavigationStack {
            List {
                if !showSearch {
                    defaultListView
                } else {
                    if searchText.isEmpty {
                        HStack {
                            Spacer()
                            Text("Search a Word, Lesson or Year Level")
                            Spacer()
                        }
                        .foregroundStyle(Color.gray)
                        .font(.subheadline)
                        .listRowBackground(Color.clear)
                    } else {
                        searchView
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Year Levels")
            .navigationDestination(for: Lesson.self) { lesson in
                LessonsListView(lesson: lesson)
            }
            .navigationDestination(for: Vocab.self) { vocab in
                VocabDetailsView(vocab: vocab)
            }
            .searchable(text: $searchText, isPresented: $showSearch)
        }
        .onAppear {
            let levels = (1...6).map({ "P\($0)" }) + // P1-P6
                         (1...3).map({ "S\($0)" })   // S1-S3
            for level in levels {
                manager.loadYearLevel(named: level)
            }
        }
    }

    var defaultListView: some View {
        ForEach(manager.yearLevels, id: \.hashValue) { level in
            Section(level.name, isExpanded: .init(get: {
                return expansionState[level.name] ?? true
            }, set: { newValue in
                expansionState[level.name] = newValue
            })) {
                ForEach(level.lessons, id: \.hashValue) { lesson in
                    NavigationLink(value: lesson) {
                        Text(lesson.name)
                    }
                }
            }
        }
    }

    var searchView: some View {
        ForEach(manager.yearLevels, id: \.hashValue) { (level: YearLevel) in
            if levelContainsSearch(level: level, term: searchText) {
                Section(level.name, isExpanded: .init(get: {
                    return expansionState[level.name] ?? true
                }, set: { newValue in
                    expansionState[level.name] = newValue
                })) {
                    ForEach(level.lessons, id: \.hashValue) { (lesson: Lesson) in
                        if lessonContainsSearch(lesson: lesson, term: searchText) {
                            NavigationLink(value: lesson) {
                                Text(lesson.name)
                            }
                            ForEach(lesson.vocab, id: \.hashValue) { (vocab: Vocab) in
                                if vocab.word.lowercased().contains(searchText) {
                                    NavigationLink(value: vocab) {
                                        Text(vocab.word).padding(.leading, 20)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func levelContainsSearch(level: YearLevel, term: String) -> Bool {
        let lowerterm = term.lowercased()
        if level.name.lowercased().contains(lowerterm) { return true }
        if level.lessons.contains(where: { lessonContainsSearch(lesson: $0, term: term) }) { return true }
        return false
    }

    func lessonContainsSearch(lesson: Lesson, term: String) -> Bool {
        let lowerterm = term.lowercased()
        if lesson.name.lowercased().contains(lowerterm) { return true }
        if lesson.vocab.contains(where: { $0.word.lowercased().contains(term) }) { return true }
        return false
    }
}

#Preview {
    ContentView()
}
