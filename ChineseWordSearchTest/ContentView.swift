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

    var body: some View {
        NavigationStack {
            List {
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
            .listStyle(.sidebar)
            .navigationTitle("Year Levels")
            .navigationDestination(for: Lesson.self) { lesson in
                LessonsListView(lesson: lesson)
            }
        }
        .onAppear {
            manager.loadYearLevel(named: "P1")
            manager.loadYearLevel(named: "P2")
        }
    }
}

#Preview {
    ContentView()
}
