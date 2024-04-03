//
//  FolderOrVocabID.swift
//
//
//  Created by Kai Quan Tay on 3/4/24.
//

import Foundation

public enum FolderOrVocabID: Identifiable, Hashable {
    case folder(UUID)
    case vocab(UUID)

    public var id: UUID {
        switch self {
        case .folder(let uUID): uUID
        case .vocab(let uUID): uUID
        }
    }
}
