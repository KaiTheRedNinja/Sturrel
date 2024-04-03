//
//  QuizResultsView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 25/10/23.
//

import SwiftUI
import SturrelTypes
import SturrelQuiz
import SturrelThemesUI

public struct QuizResultsView: View {
    @ObservedObject var quizManager: QuizManager

    @State var questionSortMode: QuestionSortMode = .all

    @Environment(\.presentationMode) var presentationMode

    public init(quizManager: QuizManager, questionSortMode: QuestionSortMode = .all) {
        self.quizManager = quizManager
        self.questionSortMode = questionSortMode
    }

    public enum QuestionSortMode: String, CaseIterable, Identifiable {
        case all
        case correct
        case incorrect

        public var id: String { self.rawValue }
    }

    public var body: some View {
        ThemedList {
            let distribution = [Question:[QuestionAttempt]].init(grouping: quizManager.attempts) { $0.question }

            Section {
                // number of questions
                Text("\(quizManager.questions.count)").bold() +
                Text(" Questions")

                // number of attempts
                // number of incorrect
                // number of correct
                VStack {
                    Text("\(quizManager.attempts.count) Attempts")
                    Text("\(quizManager.attempts.filter({ $0.isCorrect }).count) Correct")
                    Text("\(quizManager.attempts.filter({ !$0.isCorrect }).count) Incorrect")
                    HStack(spacing: 0) {
                        ForEach(quizManager.attempts) { attempt in
                            if attempt.isCorrect {
                                Color.green
                            } else {
                                Color.red
                            }
                        }
                    }
                    .mask {
                        RoundedRectangle(cornerRadius: 5)
                    }
                    .frame(height: 10)
                }

                // average attempts per question
                // maximum attempts per question
                // distribution of attempts per question (graph)
//                HStack {
//                    let maxAttempts = Double(distribution.values.max(by: { $0.count < $1.count })?.count ?? 0)
//                    ScrollView(.horizontal) {
//                        HStack(alignment: .bottom) {
//                            ForEach(distribution.keys.sorted(by: { (distribution[$0]?.count ?? 0) < (distribution[$1]?.count ?? 0) })) { question in
//                                if let attempts = distribution[question] {
//                                    VStack(spacing: 0) {
//                                        ForEach(0..<attempts.filter({ $0.isCorrect }).count, id: \.self) { _ in
//                                            Color.green.frame(width: 40, height: 200.0/maxAttempts)
//                                        }
//                                        ForEach(0..<attempts.filter({ !$0.isCorrect }).count, id: \.self) { _ in
//                                            Color.red.frame(width: 40, height: 200.0/maxAttempts)
//                                        }
//                                        Text(question.question)
//                                            .rotationEffect(.degrees(90))
//                                            .padding(.top, 10)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
            }

            Section {
                HStack {
                    Spacer()
                    Button("Replay") {
                        quizManager.restart()
                    }
                    .tint(Color.additional)
                    Spacer()
                    Button("Exit") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)

            Section {
                // filter by correct/wrong/all questions
                // list of questions + answer + accuracy + wrong answers
                Picker("Question Filter", selection: $questionSortMode) {
                    ForEach(QuestionSortMode.allCases) { sortMode in
                        Text(sortMode.rawValue)
                            .tag(sortMode)
                    }
                }

                ForEach(shownQuestions(for: distribution)) { question in
                    VStack(alignment: .leading) {
                        Text(question.question)
                        GroupBox {
                            ZStack(alignment: .leading) {
                                Color.clear.frame(height: 3)
                                Text(question.answer)
                                    .foregroundStyle(Color.primary.opacity(0.6))
                            }
                        }
                        .backgroundStyle(Color.green)
                        if distribution[question]?.contains(where: { !$0.isCorrect }) ?? false {
                            GroupBox {
                                ZStack(alignment: .leading) {
                                    Color.clear.frame(height: 3)
                                    VStack(alignment: .leading) {
                                        ForEach(distribution[question] ?? []) { attempt in
                                            if !attempt.isCorrect {
                                                Text(attempt.givenAnswer)
                                                    .foregroundStyle(Color.primary)
                                            }
                                        }
                                    }
                                }
                            }
                            .backgroundStyle(Color.red.opacity(0.6))
                        }
                    }
                }
            }
        }
    }

    func shownQuestions(for distribution: [Question:[QuestionAttempt]]) -> [Question] {
        switch questionSortMode {
        case .all:
            return Array(distribution.keys)
        case .correct:
            return distribution.keys.filter { qn in
                // doesn't contain any wrong answers
                return !(distribution[qn]?.contains(where: { !$0.isCorrect }) ?? false)
            }
        case .incorrect:
            return distribution.keys.filter { qn in
                // contains any wrong answers
                return (distribution[qn]?.contains(where: { !$0.isCorrect }) ?? false)
            }
        }
    }
}
