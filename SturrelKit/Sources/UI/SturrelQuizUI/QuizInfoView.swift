//
//  QuizInfoView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 25/10/23.
//

import SwiftUI
import SturrelQuiz

public struct QuizInfoView: View {
    @ObservedObject var quizManager: QuizManager

    public init(quizManager: QuizManager) {
        self.quizManager = quizManager
    }

    public var body: some View {
        HStack {
            ForEach(QuizStat.allCases) { stat in
                if quizManager.statsToShow.contains(stat) {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(stat.color)
                        .overlay {
                            VStack {
                                Text(stat.rawValue)
                                Text("\(quizManager[stat])")
                                    .font(.largeTitle)
                                    .bold()
                            }
                        }
                }
            }
            Button {
                for question in quizManager.questions where !quizManager.attempts.contains(where: { $0.question == question }) {
                    quizManager.makeAttempt(.init(question: question, givenAnswer: "(Not Answered)"))
                }
                quizManager.inPlay = false
            } label: {
                Image(systemName: "xmark")
            }
        }
        .frame(maxHeight: 70)
    }
}
