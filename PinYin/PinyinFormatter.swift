//
//  PinyinFormatter.swift
//  HanziPinyin
//
//  Created by Xin Hong on 16/4/16.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

let characterMap: [String: [String]] = [
    "a": ["ā", "á", "ǎ", "à", "a"],
    "e": ["ē", "é", "ě", "è", "e"],
    "i": ["ī", "í", "ǐ", "ì", "i"],
    "o": ["ō", "ó", "ǒ", "ò", "o"],
    "u": ["ū", "ú", "ǔ", "ù", "u"],
    "u:": ["ǖ", "ǘ", "ǚ", "ǜ", "ü"]
]

internal struct PinyinFormatter {
    internal static func format(_ pinyin: String) -> String {
        var formattedPinyin = pinyin

        // turn tone indicator into unicode tone indicator
        if let lastChar = formattedPinyin.last, let tone = Int(String(lastChar)) {
            for (char, alts) in characterMap {
                if pinyin.contains(char) {
                    formattedPinyin = formattedPinyin.replacingOccurrences(of: char, with: alts[tone-1])
                    break
                }
            }
            formattedPinyin = formattedPinyin.replacingOccurrences(
                of: "[1-5]",
                with: "",
                options: .regularExpression,
                range: formattedPinyin.startIndex..<formattedPinyin.endIndex
            )
        }

        // capitalise
        formattedPinyin = formattedPinyin.lowercased()

        return formattedPinyin
    }
}
