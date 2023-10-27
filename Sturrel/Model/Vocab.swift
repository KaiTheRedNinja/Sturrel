//
//  Vocab.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import Foundation

struct VocabFolder: Identifiable, Codable, Hashable {
    let id: UUID

    var name: String
    var subfolders: [VocabFolder.ID]
    var vocab: [Vocab.ID]

    init(id: UUID = .init(), name: String, subfolders: [VocabFolder.ID], vocab: [Vocab.ID]) {
        self.id = id
        self.name = name
        self.subfolders = subfolders
        self.vocab = vocab
    }

    enum Keys: CodingKey {
        case id, name, subfolders, vocab
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(subfolders, forKey: .subfolders)
        try container.encode(vocab, forKey: .vocab)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.id = (try? container.decode(UUID.self, forKey: .id)) ?? .init()
        self.name = try container.decode(String.self, forKey: .name)
        self.subfolders = (try? container.decode([VocabFolder.ID].self, forKey: .subfolders)) ?? []
        self.vocab = (try? container.decode([Vocab.ID].self, forKey: .vocab)) ?? []
    }

    func flatVocab() -> [Vocab.ID] {
        self.vocab + subfolders.compactMap({ FoldersDataManager.shared.getFolder(for: $0)?.flatVocab() }).flatMap({ $0 })
    }
}

struct Vocab: Identifiable, Codable, Hashable {
    let id: UUID

    var word: String
    var isHCL: Bool
    var englishDefinition: String
    var definition: String
    var sentences: [String]
    var wordBuilding: [String]

    init(id: UUID = .init(),
         word: String,
         isHCL: Bool = false,
         englishDefinition: String = "",
         definition: String = "",
         sentences: [String] = [],
         wordBuilding: [String] = []) {
        self.id = id
        self.word = word
        self.isHCL = isHCL
        self.englishDefinition = englishDefinition
        self.definition = definition
        self.sentences = sentences
        self.wordBuilding = wordBuilding
    }

    enum Keys: CodingKey {
        case id, word, isHCL, english_definition, definition, model_sentences, word_building
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(id, forKey: .id)
        try container.encode(word, forKey: .word)
        try container.encode(isHCL, forKey: .isHCL)
        try container.encode(englishDefinition, forKey: .english_definition)
        try container.encode(definition, forKey: .definition)
        try container.encode(sentences, forKey: .model_sentences)
        try container.encode(wordBuilding, forKey: .word_building)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.id = (try? container.decode(UUID.self, forKey: .id)) ?? .init()
        self.word = try container.decode(String.self, forKey: .word)
        self.isHCL = (try? container.decode(Bool.self, forKey: .isHCL)) ?? false
        self.englishDefinition = (try? container.decode(String.self, forKey: .english_definition)) ?? ""
        self.definition = (try? container.decode(String.self, forKey: .definition)) ?? ""
        self.sentences = (try? container.decode([String].self, forKey: .model_sentences)) ?? []
        self.wordBuilding = (try? container.decode([String].self, forKey: .word_building)) ?? []
    }
}
