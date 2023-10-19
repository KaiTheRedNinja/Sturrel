//
//  String+HanziPinyin.swift
//  HanziPinyin
//
//  Created by Xin Hong on 16/4/16.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

public extension String {
    func toPinyin(separator: String = " ") -> String {
        var pinyinStrings = [String]()
        for unicodeScalar in unicodeScalars {
            let charCodePoint = unicodeScalar.value
            let pinyinArray = HanziPinyin.pinyinArray(withCharCodePoint: charCodePoint)

            if pinyinArray.count > 0 {
                pinyinStrings.append(pinyinArray.first! + separator)
            } else {
                pinyinStrings.append(String(unicodeScalar))
            }
        }

        var pinyin = pinyinStrings.joined(separator: "")
        if !pinyin.isEmpty && String(pinyin.suffix(from: pinyin.index(pinyin.endIndex, offsetBy: -1))) == separator {
            pinyin.remove(at: pinyin.index(pinyin.endIndex, offsetBy: -1))
        }

        return pinyin
    }

    var hasChineseCharacter: Bool {
        for unicodeScalar in unicodeScalars {
            let charCodePoint = unicodeScalar.value
            if HanziPinyin.isHanzi(ofCharCodePoint: charCodePoint) {
                return true
            }
        }
        return false
    }
}
