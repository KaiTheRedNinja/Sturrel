//
//  NewVocabView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 21/10/23.
//

import SwiftUI

struct NewVocabView: View {
    var targetFolderID: VocabFolder.ID
    @State var prototypeNewVocabID: Vocab.ID!

    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var vocabDataManager: VocabDataManager = .shared

    init(targetFolderID: VocabFolder.ID) {
        self.targetFolderID = targetFolderID
    }

    var body: some View {
        NavigationStack {
            if let prototypeNewVocabID {
                VocabDetailsView(vocabID: prototypeNewVocabID)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel") {
                                vocabDataManager.removeVocab(prototypeNewVocabID)
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                    .environment(\.editMode, .init(get: { .active }, set: { newMode in
                        if newMode == .inactive {
                            FoldersDataManager.shared.bindingFolder(for: targetFolderID).wrappedValue.vocab.append(prototypeNewVocabID)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }))
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            let prototype = Vocab(word: "无标题", definition: "", sentences: [], wordBuilding: [])
            VocabDataManager.shared.saveVocab(prototype)
            prototypeNewVocabID = prototype.id
        }
    }
}
