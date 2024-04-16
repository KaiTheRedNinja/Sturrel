//
//  Quiz.swift
//
//
//  Created by Kai Quan Tay on 3/4/24.
//

import Foundation
import SturrelTypes
import PinYin

public enum Quiz: CaseIterable, Identifiable, Hashable {
    case dragAndMatch
    case memoryCards
    case qna
    case flashCards

    public var description: String {
        switch self {
        case .dragAndMatch: "Drag and Match"
        case .memoryCards: "Memory Cards"
        case .qna: "Question-Answer"
        case .flashCards: "Flash Cards"
        }
    }

    public var icon: String {
        switch self {
        case .dragAndMatch: "square.on.square"
        case .memoryCards: "square.grid.2x2"
        case .qna: "bubble.left.and.bubble.right"
        case .flashCards: "bolt"
        }
    }

    public var id: String { description }
}

public enum QAType: CaseIterable, Hashable, Identifiable {
    case hanzi
    case pinyin
    case definition

    public func forVocab(_ vocab: Vocab) -> String {
        switch self {
        case .hanzi:
            vocab.word
        case .pinyin:
            vocab.word.toPinyin()
        case .definition:
            vocab.englishDefinition
        }
    }

    public var description: String {
        switch self {
        case .hanzi:
            "Han Zi"
        case .pinyin:
            "Pin Yin"
        case .definition:
            "Definition"
        }
    }

    public var id: String { description }
}

