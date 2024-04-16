//
//  QuizManager.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 23/10/23.
//

import SwiftUI
import SturrelTypes

public class QuizManager: ObservableObject {
    /// Which stats to show in the stat screen
    public var statsToShow: Set<QuizStat>

    public var questionType: QAType
    public var answerType: QAType

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
        questionType: QAType,
        answerType: QAType,
        attempts: [QuestionAttempt] = []
    ) {
        self.statsToShow = statsToShow
        self.questions = questions
        self.questionType = questionType
        self.answerType = answerType
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
