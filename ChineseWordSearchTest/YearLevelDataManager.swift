//
//  YearLevelDataManager.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import Foundation

class YearLevelDataManager: ObservableObject {
    @Published var yearLevels: [YearLevel] = []

    func loadYearLevel(named filename: String) {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONDecoder().decode(YearLevel.self, from: data)
            yearLevels.append(jsonResult)
        } catch {
            print("Oh no error: \(error)")
        }
    }
}
