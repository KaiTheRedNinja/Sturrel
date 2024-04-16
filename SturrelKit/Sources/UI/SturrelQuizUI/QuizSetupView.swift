//
//  QuizSetupView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 23/10/23.
//

import SwiftUI
import PinYin
import SturrelTypes
import SturrelQuiz
import SturrelVocab
import SturrelThemesUI

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
                associatedVocab: vocabID,
                question: questionType.forVocab(vocab),
                answer: answerType.forVocab(vocab)
            )
        }
    }
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

public struct QuizSetupView: View {
    @ObservedObject var setupManager: QuizSetupManager

    @Environment(\.presentationMode) var presentationMode

    var folder: VocabFolder

    public init(folder: VocabFolder) {
        self.setupManager = .init(folder: folder)
        self.folder = folder

    }

    public var body: some View {
        ThemedList {
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

            Section("Play") {
                ForEach(Quiz.allCases) { quizType in
                    NavigationLink {
                        QuizAdaptor(
                            manager: .init(
                                statsToShow: [.remaining, .correct, .wrong],
                                questions: setupManager.produceQuestions(),
                                questionType: setupManager.questionType,
                                answerType: setupManager.answerType
                            ),
                            quizType: quizType
                        )
                    } label: {
                        HStack {
                            Image(systemName: quizType.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            Text(quizType.description)
                        }
                    }
                    .disabled(setupManager.includedVocab.isEmpty)
                }
            }

            Section("\(setupManager.includedVocab.count) Words") {
                ForEach(setupManager.includedVocab, id: \.self) { vocabID in
                    if let vocab = VocabDataManager.shared.getVocab(for: vocabID) {
                        HStack {
                            if vocab.isHCL {
                                Image(systemName: "staroflife.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 14)
                            }
                            Text(setupManager.questionType.forVocab(vocab))
                            Spacer()
                            Text(setupManager.answerType.forVocab(vocab))
                                .foregroundStyle(Color.additional)
                        }
                    }
                }

                if setupManager.includedVocab.isEmpty {
                    HStack {
                        Spacer()
                        Text("No Vocab")
                        Spacer()
                    }
                    .foregroundStyle(Color.additional)
                    .listRowBackground(Color.clear)
                }
            }
        }
        .navigationTitle("Quiz Setup")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Exit") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

extension VocabFolder {
    public func flatVocab() -> [Vocab.ID] {
        self.vocab + subfolders.compactMap({ FoldersDataManager.shared.getFolder(for: $0)?.flatVocab() }).flatMap({ $0 })
    }
}

#Preview {
    QuizSetupView(folder: .init(name: "HI", subfolders: [], vocab: []))
}
