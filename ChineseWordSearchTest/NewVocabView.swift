//
//  NewVocabView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 21/10/23.
//

import SwiftUI

struct NewVocabView: View {
    @Binding var folder: VocabFolder
    @Binding var prototypeNewVocab: Vocab?

    var body: some View {
        NavigationStack {
            VocabDetailsView(
                vocab: .init(
                    get: {
                        prototypeNewVocab!
                    },
                    set: { newValue in
                        prototypeNewVocab = newValue
                    }
                )
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        prototypeNewVocab = nil
                    }
                }
            }
            .environment(\.editMode, .init(get: { .active }, set: { newMode in
                if newMode == .inactive {
                    folder.vocab.append(prototypeNewVocab!)
                    prototypeNewVocab = nil
                }
            }))
        }
    }
}
