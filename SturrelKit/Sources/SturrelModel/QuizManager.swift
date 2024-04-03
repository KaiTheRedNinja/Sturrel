//
//  QuizManager.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 23/10/23.
//

import SwiftUI
import SturrelTypes

public enum Quiz: CaseIterable, Identifiable, Hashable {
    case dragAndMatch
    //    case memoryCards
    //    case qna
    //    case flashCards

    public var description: String {
        switch self {
        case .dragAndMatch:
            "Drag and Match"
        }
    }

    public var id: String { description }
}

public class QuizManager: ObservableObject {
    /// Which stats to show in the stat screen
    public var statsToShow: Set<QuizStat>

    /// The questions for the quiz view
    @Published public private(set) var questions: [Question]
    @Published public private(set) var questionIndex: Int

    /// The attempts to solve the question
    /// From this, you can get the total questions answered, the number of wrong answers, and right answers.
    @Published public private(set) var attempts: [QuestionAttempt] = []

    /// If the game is currently playing
    @Published public var inPlay: Bool = true

    public init(
        statsToShow: Set<QuizStat>,
        questions: [Question],
        attempts: [QuestionAttempt] = []
    ) {
        self.statsToShow = statsToShow
        self.questions = questions
        self.questionIndex = 0
        self.attempts = attempts
    }

    public func nextQuestion() -> Question? {
        guard questions.count > questionIndex else { return nil }
        defer {
            questionIndex += 1
        }
        return questions[questionIndex]
    }

    public func makeAttempt(_ attempt: QuestionAttempt) {
        attempts.append(attempt)
    }

    public subscript (_ stat: QuizStat) -> Int {
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

    public func restart() {
        questionIndex = 0
        attempts = []
        inPlay = true
    }
}

public struct Question: Identifiable, Hashable {
    public var id = UUID()

    public var associatedVocab: Vocab.ID
    public var question: String
    public var answer: String

    public init(id: UUID = UUID(), associatedVocab: Vocab.ID, question: String, answer: String) {
        self.id = id
        self.associatedVocab = associatedVocab
        self.question = question
        self.answer = answer
    }
}

public struct QuestionAttempt: Identifiable, Hashable {
    public var id = UUID()

    public var question: Question
    public var givenAnswer: String

    public var isCorrect: Bool {
        givenAnswer == question.answer
    }

    public init(id: UUID = UUID(), question: Question, givenAnswer: String) {
        self.id = id
        self.question = question
        self.givenAnswer = givenAnswer
    }
}

public enum QuizStat: String, CaseIterable, Identifiable {
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

    public var id: String { self.rawValue }

    /// The colors for each stat, used in the stats view of ``QuizProtocolView``
    public static let colors: [QuizStat: Color] = [
        .total: Color.orange,
        .completed: Color.indigo,
        .remaining: Color.cyan,
        .wrong: Color.red,
        .correct: Color.green
    ]

    /// The color for the `Stat`, which redirects to the ``colors`` static property of `Stat`.
    public var color: Color {
        QuizStat.colors[self] ?? Color.clear
    }
}
