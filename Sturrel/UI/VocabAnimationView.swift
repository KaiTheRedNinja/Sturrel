//
//  VocabAnimationView.swift
//  Sturrel
//
//  Created by Kai Quan Tay on 27/11/23.
//

import SwiftUI

struct VocabAnimationView: View {
    var vocab: Vocab
    @State var action: CharacterAction? = nil

    @State var state: CharacterState = .plain

    enum CharacterState: Equatable {
        case plain // where it starts
        case playing
        case paused
    }

    var body: some View {
        VStack {
            HStack {
                let pinyin = vocab.word.toPinyin().split(separator: " ")
                ForEach(0..<vocab.word.count, id: \.self) { index in
                    VStack(alignment: .center) {
                        let vocabIndex = vocab.word.index(vocab.word.startIndex, offsetBy: index)
                        CharacterView(String(vocab.word[vocabIndex...vocabIndex]), action: $action)
                            .frame(width: 100, height: 100)
                        Text(pinyin[index])
                            .font(.title3)
                            .foregroundStyle(Color.additional)
                    }
                }
            }

            Spacer()

            HStack {
                Button {
                    action = .startCharAnimation
                    state = .playing
                } label: {
                    Image(systemName: state == .plain ? "play" : "arrow.clockwise")
                }

                if state == .playing {
                    Button {
                        action = .pauseCharAnimation
                        state = .paused
                    } label: {
                        Image(systemName: "pause")
                    }
                }

                if state == .paused {
                    Button {
                        action = .resumeAnimation
                        state = .playing
                    } label: {
                        Image(systemName: "play")
                    }
                }
            }
            .font(.title)
        }
    }
}

//#Preview {
//    if #available(iOS 17.0, *) {
//        VocabAnimationView(vocab: .init(word: "早安"))
//            .containerRelativeFrame(.vertical, count: 3, spacing: 0)
//    } else {
//        // Fallback on earlier versions
//        VocabAnimationView(vocab: .init(word: "早安"))
//    }
//}
