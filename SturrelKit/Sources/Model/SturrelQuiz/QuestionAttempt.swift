//
//  QuestionAttempt.swift
//
//
//  Created by Kai Quan Tay on 3/4/24.
//

import Foundation

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
