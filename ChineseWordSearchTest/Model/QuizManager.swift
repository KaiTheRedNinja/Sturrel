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
    var statsToShow: Set<QuizStat>

    /// The questions for the quiz view
    @Published private(set) var questions: [Question]
    @Published private(set) var questionIndex: Int

    /// The attempts to solve the question
    /// From this, you can get the total questions answered, the number of wrong answers, and right answers.
    @Published private(set) var attempts: [QuestionAttempt] = []

    /// If the game is currently playing
    @Published var inPlay: Bool = true

    init(
        statsToShow: Set<QuizStat>,
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

    subscript (_ stat: QuizStat) -> Int {
        switch stat {
        case .total:
            questions.count
        case .completed:
            questionIndex
        case .remaining:
            questions.count - questionIndex
        case .wrong:
            attempts.filter({ !$0.isCorrect }).count
        case .correct:
            attempts.filter({ $0.isCorrect }).count
        }
    }

    func restart() {
        questionIndex = 0
        attempts = []
        inPlay = true
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

enum QuizStat: String, CaseIterable, Identifiable {
    /// The number of questions in the quiz
    case total = "Total"
    /// The number of questions completed in the quiz
    case completed = "Completed"
    /// The remaining questions
    case remaining = "Remaining"
    /// How many wrong answers were given
    case wrong = "Wrong"
    /// How many correct answers were given
    case correct = "Correct"

    var id: String { self.rawValue }

    /// The colors for each stat, used in the stats view of ``QuizProtocolView``
    static let colors: [QuizStat: Color] = [
        .total: Color.orange,
        .completed: Color.indigo,
        .remaining: Color.cyan,
        .wrong: Color.red,
        .correct: Color.green
    ]

    /// The color for the `Stat`, which redirects to the ``colors`` static property of `Stat`.
    var color: Color {
        QuizStat.colors[self] ?? Color.clear
    }
}
