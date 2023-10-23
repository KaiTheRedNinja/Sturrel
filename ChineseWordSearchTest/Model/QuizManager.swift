//
//  QuizManager.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 23/10/23.
//

import SwiftUI

enum Quiz: CaseIterable, Identifiable, Hashable {
    case dragAndMatch
    //    case memoryCards
    //    case qna
    //    case flashCards

    var description: String {
        switch self {
        case .dragAndMatch:
            "Drag and Match"
        }
    }

    var id: String { description }
}

class QuizManager: ObservableObject {
    /// Which stats to show in the stat screen
    var statsToShow: [Stat]

    /// The questions for the quiz view
    @Published var questions: [Question]

    /// The total number of questions in the quiz
    var total: Int { questions.count }
    /// The total number of completed questions in the quiz
    @Published var completed: Int = 0
    /// The total number of wrong questions in the quiz
    @Published var wrong: Int = 0
    /// The total number of correct questions in the quiz
    @Published var correct: Int = 0

    /// The attempts to solve the question
    var attempts: [QuestionAttempt] = []

    init(
        statsToShow: [Stat],
        questions: [Question],
        completed: Int = 0,
        wrong: Int = 0,
        correct: Int = 0,
        attempts: [QuestionAttempt] = []
    ) {
        self.statsToShow = statsToShow
        self.questions = questions
        self.completed = completed
        self.wrong = wrong
        self.correct = correct
        self.attempts = attempts
    }
}

struct Question: Identifiable, Hashable {
    var id = UUID()

    var question: String
    var answer: String
}

struct QuestionAttempt: Identifiable, Hashable {
    var id = UUID()

    var question: Question
    var givenAnswer: String

    var isCorrect: Bool {
        givenAnswer == question.answer
    }
}

enum Stat: CaseIterable {
    /// The number of questions in the quiz
    case total
    /// The number of questions completed in the quiz
    case completed
    /// The remaining questions
    case remaining
    /// How many wrong answers were given
    case wrong
    /// How many correct answers were given
    case correct

    /// The colors for each stat, used in the stats view of ``QuizProtocolView``
    static let colors: [Stat: Color] = [
        .total: Color.orange,
        .completed: Color.indigo,
        .remaining: Color.cyan,
        .wrong: Color.red,
        .correct: Color.green
    ]

    /// The color for the `Stat`, which redirects to the ``colors`` static property of `Stat`.
    var color: Color {
        Stat.colors[self] ?? Color.clear
    }
}
