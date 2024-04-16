//
//  FlashCardsQuiz.swift
//
//
//  Created by Kai Quan Tay on 16/4/24.
//

import SwiftUI
import SturrelQuiz

struct FlashCardsQuiz: View {
    var question: () -> Question
    var didAttemptQuestion: (QuestionAttempt) -> Void

    @State var flipped: Bool = false
    @State var attempt: QuestionAttempt?
    @State var inPosition: Bool = false

    init(
        question: @escaping @autoclosure () -> Question,
        didAttemptQuestion: @escaping (QuestionAttempt) -> Void) {
        self.question = question
        self.didAttemptQuestion = didAttemptQuestion
    }

    var body: some View {
        VStack {
            let horizontalOffset: CGFloat = if let attempt {
                if attempt.isCorrect {
                    -300
                } else {
                    300
                }
            } else {
                0
            }

            FlashCard(
                question: question(),
                flipped: flipped
            ) {
                flipped.toggle()
            }
            .offset(x: horizontalOffset, y: inPosition ? 0 : 700)
            .opacity(attempt == nil ? 1 : 0)
            .padding(30)
            .id(question().id)

            HStack(spacing: 30) {
                FlashCardButton(
                    text: "I know this",
                    color: .green
                ) {
                    withAnimation {
                        attempt = QuestionAttempt(
                            question: question(),
                            givenAnswer: question().answer
                        )
                    }
                    didAttemptQuestion(attempt!)
                }

                FlashCardButton(
                    text: "I don't know this",
                    color: .red
                ) {
                    withAnimation {
                        attempt = QuestionAttempt(
                            question: question(),
                            givenAnswer: "Unfamiliar"
                        )
                    }
                    didAttemptQuestion(attempt!)
                }
            }
            .frame(height: 100)
        }
        .padding(30)
        .onChange(of: question()) { _ in
            flipped = false
            attempt = nil
            inPosition = false
            withAnimation {
                inPosition = true
            }
        }
        .onAppear {
            withAnimation {
                inPosition = true
            }
        }
    }
}

struct FlashCard: View {
    var question: Question
    var flipped: Bool
    var onTap: () -> Void

    @State var rotation = 0.0
    @State var cardColor = Color.green

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(cardColor)
            .aspectRatio(0.7, contentMode: .fit)
            .overlay {
                if rotation > 90 {
                    Text(question.answer)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                } else {
                    Text(question.question)
                }
            }
            .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
            .onChange(of: flipped) { _ in
                withAnimation {
                    rotation = flipped ? 180 : 0
                    cardColor = flipped ? Color.purple : Color.green
                }
            }
            .onTapGesture {
                onTap()
            }
    }
}

struct FlashCardButton: View {
    var text: String
    var color: Color
    var onTap: () -> Void

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(color)
            .overlay {
                Text(text)
            }
            .onTapGesture {
                onTap()
            }
    }
}
