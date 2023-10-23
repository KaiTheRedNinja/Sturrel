//
//  QuizSetupView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 23/10/23.
//

import SwiftUI

class QuizSetupManager: ObservableObject {
    @Published var questionType: QAType = .hanzi
    @Published var answerType: QAType = .pinyin
    @Published var randomised: Bool = true
    @Published var quizExtent: QuizExtent = .allVocab

    var folder: VocabFolder

    var includedVocab: [Vocab.ID] {
        switch quizExtent {
        case .directVocabOnly:
            folder.vocab
        case .allVocab:
            folder.flatVocab()
        }
    }

    init(folder: VocabFolder) {
        self.folder = folder
    }

    func produceQuestions() -> [Question] {
        includedVocab.compactMap { vocabID in
            guard let vocab = VocabDataManager.shared.getVocab(for: vocabID) else { return nil }
            return Question(
                question: questionType.forVocab(vocab),
                answer: answerType.forVocab(vocab)
            )
        }
    }
}

enum QAType: CaseIterable, Hashable, Identifiable {
    case hanzi
    case pinyin

    func forVocab(_ vocab: Vocab) -> String {
        switch self {
        case .hanzi:
            vocab.word
        case .pinyin:
            vocab.word.toPinyin()
        }
    }

    var description: String {
        switch self {
        case .hanzi:
            "Han Zi"
        case .pinyin:
            "Pin Yin"
        }
    }

    var id: String { description }
}

enum QuizExtent: CaseIterable, Hashable, Identifiable {
    case directVocabOnly
    case allVocab

    var description: String {
        switch self {
        case .directVocabOnly:
            "This Folder's Only"
        case .allVocab:
            "This Folder and Subfolders'"
        }
    }

    var id: String { description }
}

struct QuizSetupView: View {
    @ObservedObject var setupManager: QuizSetupManager

    var folder: VocabFolder
    var quiz: Quiz

    init(folder: VocabFolder, quiz: Quiz) {
        self.setupManager = .init(folder: folder)
        self.folder = folder
        self.quiz = quiz
    }

    var body: some View {
        List {
            Section {
                HStack {
                    VStack {
                        Text("Question")
                        Color.clear.frame(height: 1)
                        Picker("", selection: $setupManager.questionType) {
                            ForEach(QAType.allCases) { qaType in
                                Text(qaType.description)
                                    .tag(qaType)
                            }
                        }
                        .fixedSize(horizontal: true, vertical: false)
                        .padding(.top, -6)
                    }
                    Divider()
                    VStack {
                        Text("Answer")
                        Color.clear.frame(height: 1)
                        Picker("", selection: $setupManager.answerType) {
                            ForEach(QAType.allCases) { qaType in
                                Text(qaType.description)
                                    .tag(qaType)
                            }
                        }
                        .fixedSize(horizontal: true, vertical: false)
                        .padding(.top, -6)
                    }
                }
                .pickerStyle(.menu)
                .multilineTextAlignment(.center)
                Picker("Tested Vocab:", selection: $setupManager.quizExtent) {
                    ForEach(QuizExtent.allCases) { extent in
                        Text(extent.description)
                            .tag(extent)
                    }
                }
                Toggle("Randomised", isOn: $setupManager.randomised)
            }

            Section {
                ForEach(setupManager.includedVocab, id: \.self) { vocabID in
                    if let vocab = VocabDataManager.shared.getVocab(for: vocabID) {
                        HStack {
                            if vocab.isHCL {
                                Image(systemName: "staroflife.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 14)
                            }
                            Text(vocab.word)
                            Spacer()
                            Text(vocab.word.toPinyin())
                                .foregroundStyle(Color.gray)
                        }
                    }
                }

                if setupManager.includedVocab.isEmpty {
                    HStack {
                        Spacer()
                        Text("No Vocab")
                        Spacer()
                    }
                    .foregroundStyle(Color.gray)
                    .listRowBackground(Color.clear)
                }
            }

            Section {
                NavigationLink("Play") {
                    switch quiz {
                    case .dragAndMatch:
                        Text("Drag and match")
                    }
                }
                .disabled(setupManager.includedVocab.isEmpty)
            }
        }
        .navigationTitle("Quiz Setup")
    }
}

#Preview {
    QuizSetupView(folder: .init(name: "HI", subfolders: [], vocab: []), quiz: .dragAndMatch)
}
