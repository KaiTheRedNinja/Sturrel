//
//  SearchResult.swift
//
//
//  Created by Kai Quan Tay on 3/4/24.
//

import Foundation
import SturrelTypes

public struct SearchResult: Identifiable {
    /// An array representing the steps, where the first item is the direct parent of the result, and
    /// the last item is a direct child of Root
    public var steps: [UUID]

    /// The ID of the actual result
    public var result: FolderOrVocabID

    public var id: UUID {
        result.id
    }

    public func adding(parent: UUID) -> SearchResult {
        var mutableSelf = self
        mutableSelf.steps.append(parent)
        return mutableSelf
    }
}

