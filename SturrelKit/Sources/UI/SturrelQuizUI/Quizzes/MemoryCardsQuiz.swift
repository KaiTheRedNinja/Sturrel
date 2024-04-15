//
//  MemoryCardsQuiz.swift
//
//
//  Created by Kai Quan Tay on 15/4/24.
//

import SwiftUI
import SturrelQuiz

struct QAItem: Identifiable, Hashable {
    var id: UUID = .init()
    var qaType: QuestionOrAnswer
    var question: Question

    func text() -> String {
        switch qaType {
        case .qn: question.question
        case .ans: question.answer
        }
    }
}

enum QuestionOrAnswer {
    case qn, ans
}

struct MemoryCardsQuiz: View {
    let loadedQuestions: () -> [Question]
    let questionSet: Int
    let didAttemptQuestion: (QuestionAttempt) -> Void

    init(loadedQuestions: @escaping @autoclosure () -> [Question], questionSet: Int, didAttemptQuestion: @escaping (QuestionAttempt) -> Void) {
        self.loadedQuestions = loadedQuestions
        self.questionSet = questionSet
        self.didAttemptQuestion = didAttemptQuestion
    }

    @State var clickedItem: QAItem?
    @State var referenceItem: QAItem?
    @State var showAll: Bool = true
    @State var allowFlips: Bool = false
    @State var gridSize: Int = 2
    @State var order: [QAItem?] = []

    func refresh() {
        print("Refreshing!")
        print("Loaded questions: \(loadedQuestions().map({ $0.question }))")
        // determine the size of grid, by the closest square number to 2*qnCount
        let qnCount = loadedQuestions().count
        gridSize = 2
        while (gridSize*gridSize < qnCount*2) { gridSize += 1 }

        // populate `order`
        let items = loadedQuestions().map { QAItem(qaType: QuestionOrAnswer.qn, question: $0) } +
        loadedQuestions().map { QAItem(qaType: QuestionOrAnswer.ans, question: $0) }

        order = items.shuffled()

        showAll = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showAll = false
            clickedItem = nil
            referenceItem = nil
            allowFlips = true
        }
    }

    var body: some View {
        VStack {
            gameView
        }
        .onChange(of: questionSet) { _ in
            refresh()
        }
        .onAppear {
            refresh()
        }
        .padding(.horizontal, 16)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }

    var gameView: some View {
        VStack {
            ForEach(0..<gridSize, id: \.self) { rowNum in
                HStack {
                    ForEach(0..<gridSize, id: \.self) { colNum in
                        let index = rowNum*gridSize + colNum
                        if let item = (index < order.count) ? order[index] : nil {
                            MemoryCard(
                                qaItem: item,
                                flipped: showAll ||
                                         clickedItem?.id == item.id ||
                                         referenceItem?.id == item.id
                            ) {
                                guard allowFlips else { return }

                                if (clickedItem == nil) { // no clicked item
                                    clickedItem = item
                                } else if (clickedItem?.id == item.id) { // clicked item is this
                                    clickedItem = nil
                                } else { // clicked item is not this card
                                    referenceItem = item
                                    checkMatch(item1: clickedItem!, item2: item)
                                }
                            }
                        } else {
                            Color.clear
                        }
                    }
                }
            }
        }
    }

    func checkMatch(item1: QAItem, item2: QAItem) {
        allowFlips = false
        var mutableOrder = order

        if (item1.question.id != item2.question.id) {
            // got it wrong
            let attempt = QuestionAttempt(question: item1.question, givenAnswer: item2.text())
            didAttemptQuestion(attempt)
        } else {
            // got it right!
            let attempt = QuestionAttempt(question: item1.question, givenAnswer: item1.question.answer)
            didAttemptQuestion(attempt)
            // remove the item from `order`
            for i in 0..<order.count {
                let curItem = order[i]
                if (curItem?.id == item1.id || curItem?.id == item2.id) {
                    mutableOrder[i] = nil
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            clickedItem = nil
            referenceItem = nil
            allowFlips = true
            // if `mutableOrder` is all nulls, don't assign it
            if mutableOrder.contains(where: { $0 != nil }) {
                order = mutableOrder
            }
        }
    }
}

struct MemoryCard: View {
    var qaItem: QAItem
    var flipped: Bool
    var onTap: () -> Void

    @State var rotation = 0.0
    @State var cardColor = Color.green

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(cardColor)
            .overlay {
                if rotation < 90 {
                    Text(qaItem.text())
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
