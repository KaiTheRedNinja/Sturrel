//
//  Quiz.swift
//
//
//  Created by Kai Quan Tay on 3/4/24.
//

import Foundation

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
