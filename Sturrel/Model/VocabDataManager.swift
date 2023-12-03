//
//  VocabDataManager.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 22/10/23.
//

import SwiftUI

final class VocabDataManager: ObservableObject {
    static var shared: VocabDataManager = .init()

    private init() {
        guard FileSystem.exists(file: .vocabs) else { return }
        vocabs = FileSystem.read([Vocab.ID: Vocab].self, from: .vocabs) ?? [:]
    }

    @Published private var vocabs: [Vocab.ID: Vocab] = [:]

    func getVocab(for id: Vocab.ID) -> Vocab? {
        return vocabs[id]
    }

    var lastCall: Date = .now
    func saveVocab(_ vocab: Vocab) {
        vocabs[vocab.id] = vocab

        let now = Date.now
        lastCall = now

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self, lastCall == now else { return }
            save()
        }
    }

    func bindingVocab(for id: Vocab.ID) -> Binding<Vocab> {
        .init {
            self.getVocab(for: id) ?? .init(id: id, word: "Untitled")
        } set: { newValue in
            self.saveVocab(newValue)
        }
    }

    func removeVocab(_ id: Vocab.ID) {
        vocabs.removeValue(forKey: id)
        save()
    }

    func removeAll() {
        vocabs = [:]
        save()
    }

    func save() {
        FileSystem.write(vocabs, to: .vocabs)
    }
}
