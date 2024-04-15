//
//  Quiz.swift
//
//
//  Created by Kai Quan Tay on 3/4/24.
//

import Foundation

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

    public var id: String { description }
}
