//
//  SwiftUIView.swift
//  
//
//  Created by Kai Quan Tay on 15/4/24.
//

import SwiftUI
import SturrelQuiz

enum SolveState {
    case correct, wrong, unselected
}

struct QuestionAnswerQuiz: View {
    var question: () -> Question
    var answerType: QAType
    var questionPool: [Question]
    var didAttemptQuestion: (QuestionAttempt) -> Void

    @State var candidateAnswers: [Question] = []
    @State var selectedAnswer: UUID?

    init(
        question: @escaping @autoclosure () -> Question,
        answerType: QAType,
        questionPool: [Question],
        didAttemptQuestion: @escaping (QuestionAttempt) -> Void
    ) {
        self.question = question
        self.answerType = answerType
        self.questionPool = questionPool
        self.didAttemptQuestion = didAttemptQuestion
    }

    func refresh(newQn: Question) {
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedAnswer = nil
        }

        // get new answers using the question pool
        guard !questionPool.isEmpty else { return }

        // select five random questions
        let maxQns = min(5, questionPool.count)
        var randomQuestions = questionPool.shuffled()[0..<maxQns]

        // if one of them is `question`, discard it, else remove the last item.
        let curQuesIndex = randomQuestions.firstIndex(of: question())
        if let curQuesIndex {
            randomQuestions.remove(at: curQuesIndex)
        } else {
            randomQuestions.removeLast()
        }

        // replace a random one with `question`
        randomQuestions[Int.random(in: 0..<randomQuestions.count)] = newQn

        withAnimation(.easeInOut(duration: 0.2)) {
            candidateAnswers = Array(randomQuestions)
        }
    }

    var body: some View {
        VStack {
            ZStack {
                Color.clear
                Text("What is the \(answerType.description) of \(question().question)?")
                    .font(.title)
            }

            VStack {
                ForEach(0..<4) { itemNum in
                    if itemNum < candidateAnswers.count {
                        let item = candidateAnswers[itemNum]
                        let solveState: SolveState? = if let selectedAnswer {
                            switch item.id {
                            case question().id: .correct
                            case selectedAnswer: .wrong
                            default: .unselected
                            }
                        } else {
                            nil
                        }
                        QuestionAnswerCard(
                            text: item.answer,
                            optionNumber: itemNum,
                            solveState: solveState
                        ) {
                            let attempt = QuestionAttempt(
                                question: question(),
                                givenAnswer: item.answer
                            )
                            didAttemptQuestion(attempt)
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedAnswer = item.id
                            }
                        }
                    } else {
                        Color.clear
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            refresh(newQn: question())
        }
        .onChange(of: question()) { newValue in
            refresh(newQn: newValue)
        }
        .padding(16)
    }
}

struct QuestionAnswerCard: View {
    var text: String
    var optionNumber: Int
    var solveState: SolveState?
    var onTap: () -> Void

    var color: Color {
        if let solveState {
            switch solveState {
            case .correct: .green
            case .wrong: .red
            case .unselected: .gray
            }
        } else {
            switch optionNumber {
            case 0: .green
            case 1: .blue
            case 2: .yellow
            case 3: .orange
            default: .gray
            }
        }
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(color)
            .overlay {
                Text(text)
                    .font(.title2)
            }
            .onTapGesture {
                onTap()
            }
    }
}
