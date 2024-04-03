//
//  VocabDataManager.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 22/10/23.
//

import SwiftUI
import SturrelTypes

public final class VocabDataManager: ObservableObject {
    public static var shared: VocabDataManager = .init()

    private init() {
        guard FileSystem.exists(file: .vocabs) else { return }
        vocabs = FileSystem.read([Vocab.ID: Vocab].self, from: .vocabs) ?? [:]
    }

    @Published private var vocabs: [Vocab.ID: Vocab] = [:]

    public func getVocab(for id: Vocab.ID) -> Vocab? {
        return vocabs[id]
    }

    public var lastCall: Date = .now
    public func saveVocab(_ vocab: Vocab) {
        vocabs[vocab.id] = vocab

        let now = Date.now
        lastCall = now

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self, lastCall == now else { return }
            save()
        }
    }

    public func bindingVocab(for id: Vocab.ID) -> Binding<Vocab> {
        .init {
            self.getVocab(for: id) ?? .init(id: id, word: "Untitled")
        } set: { newValue in
            self.saveVocab(newValue)
        }
    }

    public func removeVocab(_ id: Vocab.ID) {
        vocabs.removeValue(forKey: id)
        save()
    }

    public func removeAll() {
        vocabs = [:]
        save()
    }

    public func save() {
        FileSystem.write(vocabs, to: .vocabs)
    }
}
