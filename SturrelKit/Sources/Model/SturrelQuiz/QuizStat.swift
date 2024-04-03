//
//  QuizStat.swift
//
//
//  Created by Kai Quan Tay on 3/4/24.
//

import Foundation
import SwiftUI

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
