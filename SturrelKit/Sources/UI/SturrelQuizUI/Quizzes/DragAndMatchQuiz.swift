//
//  DragAndMatchQuiz.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 25/10/23.
//

import SwiftUI
import SturrelQuiz

struct DragAndMatchQuiz: View {
    var loadedQuestions: [Question]
    var didAttemptQuestion: (QuestionAttempt) -> Void

    @State var answers: [Question] = []
    @State var rightPosition: CGPoint = .zero
    @State var rightHeight: CGFloat = 1.0 // can't be 0 in case /0 error

    public var body: some View {
        VStack {
            gameView
        }
        .onChange(of: loadedQuestions) { newValue in
            print("Questions changed \(newValue.map({ $0.question }))")
            answers = newValue.shuffled()
        }
        .onAppear {
            print("Questions appeared \(loadedQuestions.map({ $0.answer }))")
            answers = loadedQuestions.shuffled()
        }
        .padding(.horizontal, 16)
    }

    func verifyAnswer(index: Int, pos: CGPoint) {
        let item = loadedQuestions[index]

        guard pos.x > rightPosition.x else {
            return
        }

        // determine which item it was on
        let boxHeight = rightHeight / CGFloat(loadedQuestions.count)
        let boxNo = Int((pos.y - rightPosition.y) / boxHeight)

        print("Answers: \(answers.map { $0.answer })")

        let attempt = QuestionAttempt(question: item, givenAnswer: answers[boxNo].answer)

        didAttemptQuestion(attempt)
    }

    var gameView: some View {
        HStack {
            VStack {
                ForEach(Array(loadedQuestions.enumerated()), id: \.element) { (index, question) in
                    DragMatchCard(
                        text: question.question,
                        color: Color.orange,
                        onDrop: { point in
                            verifyAnswer(index: index, pos: point)
                        }
                    )
                    .animation(.easeInOut, value: loadedQuestions)
                }
                if loadedQuestions.count < 5 {
                    ForEach(loadedQuestions.count..<5, id: \.self) { _ in
                        Color.clear
                    }
                }
            }
            .padding(.vertical, 5)
            .zIndex(3.0)
            Color.clear
            VStack {
                ForEach(answers) { question in
                    DragMatchCard(text: question.answer, color: Color.blue)
                }
                if loadedQuestions.count < 5 {
                    ForEach(loadedQuestions.count..<5, id: \.self) { _ in
                        Color.clear
                    }
                }
            }
            .overlay {
                GeometryReader { geom -> Color in
                    {
                        DispatchQueue.main.async {
                            rightPosition = geom.frame(in: .global).origin
                            rightHeight = geom.size.height
                        }
                        return Color.clear
                    }()
                }
            }
            .padding(.vertical, 5)
            .zIndex(1.0)
        }
    }
}

struct DragMatchCard: View {
    var text: String
    var color: Color
    var onDrop: ((CGPoint) -> Void)?

    @State var offset: CGSize = .zero
    @State var boxFrame: CGRect = .zero

    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(color)
            .overlay {
                GeometryReader { geom -> Color in
                    {
                        DispatchQueue.main.async {
                            boxFrame = geom.frame(in: .global)
                        }
                        return Color.clear
                    }()
                }
            }
            .overlay {
                Text(text)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 500))
                    .minimumScaleFactor(0.01)
                    .padding(7)
            }
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard onDrop != nil else { return }
                        offset = value.translation
                    }
                    .onEnded { value in
                        guard let onDrop else { return }
                        offset = value.translation

                        // get the midpoint
                        let midPoint = CGPoint(
                            x: boxFrame.midX,
                            y: boxFrame.midY
                        )

                        onDrop(midPoint)
                        withAnimation {
                            offset = .zero
                        }
                    }
            )
    }
}

//#Preview {
//    DragAndMatchQuiz()
//}
