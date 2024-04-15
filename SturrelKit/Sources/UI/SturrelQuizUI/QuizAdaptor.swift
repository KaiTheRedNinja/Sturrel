//
//  SwiftUIView.swift
//  
//
//  Created by Kai Quan Tay on 15/4/24.
//

import SwiftUI
import SturrelQuiz

struct QuizAdaptor: View {
    var manager: QuizManager
    var quizType: Quiz

    @State var loadedQuestions: [Question] = []
    @State var flashColor: Color = Color.clear
    @State var questionSet: Int = 0

    var body: some View {
        if manager.inPlay {
            ZStack {
                flashColor
                    .ignoresSafeArea(.all)
                    .animation(.easeInOut, value: flashColor)

                VStack {
                    QuizInfoView(quizManager: manager)
                        .padding(.horizontal, 15)

                    switch quizType {
                    case .dragAndMatch:
                        DragAndMatchQuiz(
                            loadedQuestions: loadedQuestions,
                            didAttemptQuestion: { attempt in
                                attemptQuestion(attempt: attempt)
                            })
                    case .memoryCards:
                        Text("Not yet")
                    case .qna:
                        Text("Not yet")
                    case .flashCards:
                        Text("Not yet")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                loadedQuestions = []
                switch quizType {
                case .dragAndMatch, .memoryCards:
                    for _ in 0..<(quizType == .dragAndMatch ? 5 : 8) {
                        let newQn = manager.nextQuestion()
                        if let newQn {
                            loadedQuestions.append(newQn)
                        }
                    }
                default:
                    // new question
                    let newQn = manager.nextQuestion()
                    if let newQn {
                        loadedQuestions.append(newQn)
                    }
                }
            }
        } else {
            QuizResultsView(quizManager: manager)
        }
    }

    func newQuestion(solvedQuestion: UUID?) {
        // if its drag and match, remove the question and replace it
        // if its memory quiz, remove the question. Only replace once all empty.
        // if its qna or flashcards, set the qn to the next one

        var newQuestions = [Question]()
        // remove question
        switch quizType {
        case .dragAndMatch, .memoryCards:
            // determine qn to remove
            guard let solvedQuestion else { break }
            let removeIndex = loadedQuestions.firstIndex(where: { $0.id == solvedQuestion })
            if let removeIndex {
                newQuestions = loadedQuestions
                _ = newQuestions.remove(at: removeIndex)
            }
        case .qna, .flashCards: break
        }

        // add questions
        switch quizType {
        case .memoryCards:
            guard newQuestions.isEmpty else { break }
            for _ in 0..<8 {
                let newQn = manager.nextQuestion()
                if let newQn {
                    newQuestions.append(newQn)
                }
            }
        default:
            // new question
            let newQn = manager.nextQuestion()
            if let newQn {
                newQuestions.append(newQn)
            }
        }

        // if the loaded questions are empty, game over.
        let endGame = newQuestions.isEmpty

        // apply the changes
        DispatchQueue.main.asyncAfter(
            deadline: .now() + ([Quiz.dragAndMatch, .memoryCards].contains(quizType) ? 0 : 0.5)
        ) {
            loadedQuestions = newQuestions
            if (endGame) {
                manager.inPlay = false
            }
            questionSet += 1
        }
    }

    func attemptQuestion(attempt: QuestionAttempt) {
        if attempt.isCorrect {
            flashColor = Color.green.opacity(0.5)
            newQuestion(solvedQuestion: attempt.question.id)
        } else {
            flashColor = Color.red.opacity(0.5)
            if (quizType == Quiz.qna || quizType == Quiz.flashCards) {
                newQuestion(solvedQuestion: attempt.question.id)
            }
        }

        if (quizType == Quiz.flashCards) {
            flashColor = Color.clear
        }

        manager.makeAttempt(attempt)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            flashColor = Color.clear
        }
    }
}
