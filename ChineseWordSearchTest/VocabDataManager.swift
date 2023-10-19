//
//  VocabDataManager.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import Foundation

class VocabDataManager: ObservableObject {
    @Published var root: VocabFolder = .init(name: "Folders", subfolders: [], vocab: [])

    let defaultYears: [String] = [
        "DEFAULT_P1",
        "DEFAULT_P2",
        "DEFAULT_P3",
        "DEFAULT_P4",
        "DEFAULT_P5",
        "DEFAULT_P6",
        "DEFAULT_S1",
        "DEFAULT_S2",
        "DEFAULT_S3"
    ]

    func loadDefaultFolders() {
        for defaultYear in defaultYears {
            loadFolder(named: defaultYear)
        }
    }

    func loadFolder(named filename: String) {
        if defaultYears.contains(filename) {
            loadDefaultFile(named: filename)
            return
        }
    }

    private func loadDefaultFile(named filename: String) {
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
