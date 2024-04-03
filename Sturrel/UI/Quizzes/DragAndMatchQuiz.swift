//
//  DragAndMatchQuiz.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 25/10/23.
//

import SwiftUI
import SturrelQuiz

struct DragAndMatchQuiz: View {
    @ObservedObject var quizManager: QuizManager

    @State var loadedQuestions: [Question] = []

    var body: some View {
        VStack {
            if quizManager.inPlay {
                VStack {
                    QuizInfoView(quizManager: quizManager)
                    Divider()
                    gameView
                }
                .padding(.horizontal, 16)
            } else {
                QuizResultsView(quizManager: quizManager)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }

    var gameView: some View {
        HStack {
            VStack {
                ForEach(loadedQuestions) { question in
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.orange)
                        .overlay {
                            Text(question.question)
                                .font(.system(size: 500))
                                .minimumScaleFactor(0.01)
                                .padding(7)
                        }
                        .draggable(question.id.uuidString)
                }
                if loadedQuestions.count < 5 {
                    ForEach(loadedQuestions.count..<5, id: \.self) { _ in
                        Color.clear
                    }
                }
            }
            .padding(.vertical, 5)
            Color.clear
            VStack {
                ForEach(loadedQuestions.shuffled()) { question in
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.blue)
                        .overlay {
                            Text(question.answer)
                                .font(.system(size: 500))
                                .minimumScaleFactor(0.01)
                                .padding(7)
                        }
                        .dropDestination(for: String.self) { items, location in
                            guard
                                let item = items.first,
                                let questionId = UUID(uuidString: item),
                                let correspondingQuestion = quizManager.questions.first(where: { $0.id == questionId })
                            else { return false }

                            quizManager.makeAttempt(.init(question: question, givenAnswer: correspondingQuestion.answer))
                            if correspondingQuestion.id == question.id {
                                withAnimation {
                                    loadedQuestions.removeAll(where: { $0.id == question.id })
                                    if let newQuestion = quizManager.nextQuestion() {
                                        loadedQuestions.append(newQuestion)
                                    } else if loadedQuestions.isEmpty {
                                        quizManager.inPlay = false
                                    }
                                }
                            }
                            return true
                        }
                }
                if loadedQuestions.count < 5 {
                    ForEach(loadedQuestions.count..<5, id: \.self) { _ in
                        Color.clear
                    }
                }
            }
            .padding(.vertical, 5)
        }
        .onAppear {
            loadedQuestions = []
            for _ in 0..<5 {
                guard let newQuestion = quizManager.nextQuestion() else { break }
                loadedQuestions.append(newQuestion)
            }
        }
    }
}

//#Preview {
//    DragAndMatchQuiz()
//}
