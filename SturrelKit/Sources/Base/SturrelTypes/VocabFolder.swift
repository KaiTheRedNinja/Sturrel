//
//  VocabFolder.swift
//
//
//  Created by Kai Quan Tay on 3/4/24.
//

import Foundation

public struct VocabFolder: Identifiable, Codable, Hashable {
    public let id: UUID

    public var name: String
    public var subfolders: [VocabFolder.ID]
    public var vocab: [Vocab.ID]

    public init(id: UUID = .init(), name: String, subfolders: [VocabFolder.ID], vocab: [Vocab.ID]) {
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
}
