//
//  Question.swift
//
//
//  Created by Kai Quan Tay on 3/4/24.
//

import Foundation
import SturrelTypes

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
