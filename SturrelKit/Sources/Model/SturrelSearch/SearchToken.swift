//
//  SearchToken.swift
//  
//
//  Created by Kai Quan Tay on 3/4/24.
//

import Foundation

public enum SearchToken: String, Identifiable, CaseIterable {
    public var id: String { rawValue }

    case folders = "Folders"
    case vocab = "Vocab"
}
