//
//  HanziPinyin.swift
//  HanziPinyin
//
//  Created by Xin Hong on 16/4/16.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

internal struct HanziCodePoint {
    static let start: UInt32 = 0x4E00
    static let end: UInt32 = 0x9FFF
}

internal struct HanziPinyin {
    internal static let sharedInstance = HanziPinyin()
    internal fileprivate(set) var unicodeToPinyinTable = [String: String]()

    init() {
        unicodeToPinyinTable = initializeResource()
        print("Table size: \(unicodeToPinyinTable.count)")
    }

    internal static func pinyinArray(withCharCodePoint charCodePoint: UInt32, indicateTone: Bool) -> [String] {
        func isValidPinyin(_ pinyin: String) -> Bool {
            return pinyin != "(none0)" && pinyin.hasPrefix("(") && pinyin.hasSuffix(")")
        }

        let codePointHex = String(format: "%x", charCodePoint).uppercased()
        guard let pinyin = HanziPinyin.sharedInstance.unicodeToPinyinTable[codePointHex], isValidPinyin(pinyin) else {
            return []
        }

        let leftBracketRange = pinyin.range(of: "(")!
        let rightBracketRange = pinyin.range(of: ")")!
        let processedPinyin = String(pinyin[leftBracketRange.upperBound..<rightBracketRange.lowerBound])
        let pinyinArray = processedPinyin.components(separatedBy: ",")

        let formattedPinyinArray = pinyinArray.map { (pinyin) -> String in
            return PinyinFormatter.format(pinyin, indicateTone: indicateTone)
        }
        return formattedPinyinArray
    }

    internal static func isHanzi(ofCharCodePoint charCodePoint: UInt32) -> Bool {
        return charCodePoint >= HanziCodePoint.start && charCodePoint <= HanziCodePoint.end
    }

    private class EmptyClass: NSObject {}

    private var podResourceBundle: Bundle? {
        guard let bundleURL = Bundle(for: EmptyClass.self).url(forResource: "HanziPinyin", withExtension: "bundle") else {
            return nil
        }
        print("Pod resource found")
        return Bundle(url: bundleURL)
    }

    func initializeResource() -> [String: String] {
        let resourceBundle = podResourceBundle ?? Bundle(for: EmptyClass.self)
        guard let resourcePath = resourceBundle.path(forResource: "unicode_to_hanyu_pinyin", ofType: "txt") else {
            return [:]
        }

        do {
            let unicodeToPinyinText = try String(contentsOf: URL(fileURLWithPath: resourcePath))
            let textComponents = unicodeToPinyinText.components(separatedBy: "\r\n")

            var pinyinTable = [String: String]()
            for pinyin in textComponents {
                let components = pinyin.components(separatedBy: .whitespaces)
                guard components.count > 1 else {
                    continue
                }
                pinyinTable.updateValue(components[1], forKey: components[0])
            }

            return pinyinTable
        } catch _ {
            return [:]
        }
    }
}
