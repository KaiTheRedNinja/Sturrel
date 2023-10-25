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
    @Published private(set) var questions: [Question]
    @Published private(set) var questionIndex: Int

    /// The total number of questions in the quiz
    var total: Int { questions.count }

    /// The attempts to solve the question
    /// From this, you can get the total questions answered, the number of wrong answers, and right answers.
    @Published private(set) var attempts: [QuestionAttempt] = []

    init(
        statsToShow: [Stat],
        questions: [Question],
        attempts: [QuestionAttempt] = []
    ) {
        self.statsToShow = statsToShow
        self.questions = questions
        self.questionIndex = 0
        self.attempts = attempts
    }

    func nextQuestion() -> Question? {
        guard questions.count > questionIndex else { return nil }
        defer {
            questionIndex += 1
        }
        return questions[questionIndex]
    }

    func makeAttempt(_ attempt: QuestionAttempt) {
        attempts.append(attempt)
    }
}

struct Question: Identifiable, Hashable {
    var id = UUID()

    var associatedVocab: Vocab.ID
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
