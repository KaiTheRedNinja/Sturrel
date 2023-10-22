//
//  NewVocabView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 21/10/23.
//

import SwiftUI

struct NewVocabView: View {
    var targetFolderID: VocabFolder.ID
    var prototypeNewVocabID: Vocab.ID

    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var vocabDataManager: VocabDataManager = .shared

    init(targetFolderID: VocabFolder.ID) {
        self.targetFolderID = targetFolderID

        let prototype = Vocab(word: "无标题", definition: "", sentences: [], wordBuilding: [])
        VocabDataManager.shared.saveVocab(prototype)
        self.prototypeNewVocabID = prototype.id
    }

    var body: some View {
        NavigationStack {
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
        }
    }
}
