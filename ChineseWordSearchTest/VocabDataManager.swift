//
//  VocabDataManager.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import Foundation

class VocabDataManager: ObservableObject {
    @Published var root: VocabFolder = .init(name: "Folders", subfolders: [], vocab: [])

    @Published var vocabConfiguration: VocabConfiguration! {
        didSet {
            if let vocabConfiguration {
                FileSystem.write(vocabConfiguration, to: .config)
            }
        }
    }

    func loadFromVocabConfiguration() {
        print("Loading from config at \(FileSystem.getDocumentsDirectory().absoluteString)")
        getVocabConfiguration()

        for folder in vocabConfiguration.folders {
            switch folder {
            case .builtin(let string):
                loadDefaultFolder(named: string)
            case .custom(let string):
                loadCustomFolder(named: string)
            }
        }
    }

    private func getVocabConfiguration() {
        if let config = FileSystem.read(VocabConfiguration.self, from: .config) {
            print("Loaded config! \(config)")
            self.vocabConfiguration = config
        } else {
            // P1-P6 and S1-S3
            let config = VocabConfiguration(folders: VocabConfiguration.builtins)
            print("Created config! \(config)")
            self.vocabConfiguration = config
        }
    }

    private func loadDefaultFolder(named filename: String) {
        guard let path = Bundle.main.path(forResource: "DEFAULT_" + filename, ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONDecoder().decode(VocabFolder.self, from: data)
            root.subfolders.append(jsonResult)
        } catch {
            print("Oh no error: \(error)")
        }
    }

    private func loadCustomFolder(named filename: String) {
        guard let result = FileSystem.read(VocabFolder.self, from: .customFolder(filename)) else { return }
        root.subfolders.append(result)
    }
}

struct VocabConfiguration: Codable {
    var folders: [FolderRepresentation]

    static let builtins: [FolderRepresentation] = [
        .builtin("P1"),
        .builtin("P2"),
        .builtin("P3"),
        .builtin("P4"),
        .builtin("P5"),
        .builtin("P6"),
        .builtin("S1"),
        .builtin("S2"),
        .builtin("S3")
    ]
}

enum FolderRepresentation: Codable {
    case builtin(String)
    case custom(String)
}
