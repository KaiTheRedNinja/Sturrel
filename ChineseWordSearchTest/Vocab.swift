//
//  Vocab.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import Foundation

struct VocabFolder: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var subfolders: [VocabFolder]
    var vocab: [Vocab]

    init(id: UUID = .init(), name: String, subfolders: [VocabFolder], vocab: [Vocab]) {
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
        self.subfolders = (try? container.decode([VocabFolder].self, forKey: .subfolders)) ?? []
        self.vocab = (try? container.decode([Vocab].self, forKey: .vocab)) ?? []
    }
}

struct Vocab: Codable, Hashable {
    var word: String
    var definition: String
    var sentences: [String]
    var wordBuilding: [String]
}
