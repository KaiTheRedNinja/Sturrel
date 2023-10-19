//
//  VocabDataManager.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import Foundation

class VocabDataManager: ObservableObject {
    @Published var root: VocabFolder = .init(name: "Folders", subfolders: [], vocab: [])

    func loadYearLevel(named filename: String) {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONDecoder().decode(VocabFolder.self, from: data)
            root.subfolders.append(jsonResult)
        } catch {
            print("Oh no error: \(error)")
        }
    }
}
