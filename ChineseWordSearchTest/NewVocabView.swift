//
//  NewVocabView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 21/10/23.
//

import SwiftUI

struct NewVocabView: View {
    @Binding var folder: VocabFolder
    @State var prototypeNewVocab: Vocab = .init(word: "无标题", definition: "", sentences: [], wordBuilding: [])

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VocabDetailsView(vocab: $prototypeNewVocab)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                .environment(\.editMode, .init(get: { .active }, set: { newMode in
                    if newMode == .inactive {
                        folder.vocab.append(prototypeNewVocab)
                        presentationMode.wrappedValue.dismiss()
                    }
                }))
        }
    }
}
