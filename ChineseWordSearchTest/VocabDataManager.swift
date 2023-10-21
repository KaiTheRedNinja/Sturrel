//
//  VocabDataManager.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import Foundation

class VocabDataManager: ObservableObject {
    static var shared: VocabDataManager = .init()

    private init() {}

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
        reconcileRootToVocabConfiguration()
    }

    /// Modify `root` to match `vocabConfiguration`
    func reconcileRootToVocabConfiguration() {
        var newFolders = [VocabFolder]()
        for folder in vocabConfiguration.folders {
            if let match = root.subfolders.first(where: { $0.id == folder }) {
                newFolders.append(match)
            } else if let loadedFolder = loadCustomFolder(id: folder) {
                newFolders.append(loadedFolder)
            }
        }
        root.subfolders = newFolders
    }

    /// Modify `vocabConfiguration` to match `root`
    func reconcileVocabConfigurationToRoot() {
        var newConfiguration = VocabConfiguration(folders: [])
        for subfolder in root.subfolders {
            newConfiguration.folders.append(subfolder.id)
        }
        vocabConfiguration = newConfiguration
    }

    func saveRoot() {
        // save the files in Root. Should only be called once the app is about to quit.
        for subfolder in root.subfolders {
            FileSystem.write(subfolder, to: .customFolder(subfolder.id))
        }
    }

    private func getVocabConfiguration() {
        if FileSystem.exists(file: .config), let config = FileSystem.read(VocabConfiguration.self, from: .config) {
            self.vocabConfiguration = config
        } else {
            // initialise all the data
            // transfer P1-P6 and S1-S3 files
            var config = VocabConfiguration(folders: [])
            for filename in VocabConfiguration.builtins {
                guard let builtin = loadDefaultFolder(named: filename) else { continue }
                FileSystem.write(builtin, to: .customFolder(builtin.id))
                config.folders.append(builtin.id)
            }
            self.vocabConfiguration = config
        }
    }

    private func loadDefaultFolder(named filename: String) -> VocabFolder? {
        guard let path = Bundle.main.path(forResource: "DEFAULT_" + filename, ofType: "json") else { return nil }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONDecoder().decode(VocabFolder.self, from: data)
            return jsonResult
        } catch {
            print("Oh no error: \(error)")
        }

        return nil
    }

    private func loadCustomFolder(id: UUID) -> VocabFolder? {
        guard let result = FileSystem.read(VocabFolder.self, from: .customFolder(id)) else { return nil }
        return result
    }
}

struct VocabConfiguration: Codable {
    var folders: [UUID]

    static let builtins: [String] = ["P1", "P2", "P3", "P4", "P5", "P6", "S1", "S2", "S3"]
}
