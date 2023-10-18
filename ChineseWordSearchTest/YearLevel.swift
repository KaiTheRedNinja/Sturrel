//
//  YearLevel.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import Foundation

struct YearLevel: Codable, Hashable {
    var name: String
    var lessons: [Lesson]
}

struct Lesson: Codable, Hashable {
    var name: String
    var vocab: [Vocab]
}

struct Vocab: Codable, Hashable {
    var word: String
    var sentences: [String]
    var wordBuilding: [String]
}
