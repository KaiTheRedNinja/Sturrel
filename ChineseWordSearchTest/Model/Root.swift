//
//  Root.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 18/10/23.
//

import Foundation

enum Root {
    static private(set) var id: VocabFolder.ID!

    static let builtins: [String] = ["P1", "P2", "P3", "P4", "P5", "P6", "S1", "S2", "S3"]

    static func load() {
        print("Getting contents from \(FileSystem.getDocumentsDirectory())")

        if FileSystem.exists(file: .root), let root = FileSystem.read(VocabFolder.self, from: .root) {
            id = root.id
            FoldersDataManager.shared.saveFolder(root)
        } else {
            // initialise all the data
            // transfer P1-P6 and S1-S3 files
            var subfolderIDs = [VocabFolder.ID]()
            var root = VocabFolder(name: "Folders", subfolders: [], vocab: [])

            var folders: [VocabFolder] = []
            var vocabs: [Vocab] = []

            for filename in Self.builtins {
                guard let contents = loadDefaultFolder(named: filename) else { continue }
                //                let file = VocabFolder(name: contents.name, subfolders: contents.folders.map({ $0.id }), vocab: contents.vocab.map({ $0.id }))
                let file = VocabFolder(name: contents.name, subfolders: contents.folders.map({ $0.id }), vocab: [])

                folders.append(contentsOf: contents.folders)
                vocabs.append(contentsOf: contents.vocab)

                subfolderIDs.append(file.id)
                folders.append(file)
            }

            root.subfolders = subfolderIDs

            // These have to happen async, because FoldersDataManager checks with RootDataManager
            // and produces an access error if its called before or while RootDataManager is initialising
            DispatchQueue.main.async {
                for folder in folders {
                    FoldersDataManager.shared.saveFolder(folder)
                }
                for vocab in vocabs {
                    VocabDataManager.shared.saveVocab(vocab)
                }
            }
            id = root.id
            FoldersDataManager.shared.saveFolder(root)
        }
    }

    static func save() {
        guard let root = FoldersDataManager.shared.getFolder(for: id) else { return }
        FileSystem.write(root, to: .root)
    }

    static func copyBuiltinFolder(named filename: String) {
        guard var root = FoldersDataManager.shared.getFolder(for: id),
              var builtin = loadDefaultFolder(named: filename)
        else { return }

        // change the name so that theres no conflicts
        var name = builtin.name
        if root.subfolders.compactMap({ FoldersDataManager.shared.getFolder(for: $0) }).contains(where: { $0.name == name }) {
            var counter = 2
            while root.subfolders.compactMap({ FoldersDataManager.shared.getFolder(for: $0) }).contains(where: { $0.name == "\(name) \(counter)" }) {
                counter += 1
            }
            name += " \(counter)"
        }
        builtin.name = name

        let file = VocabFolder(name: builtin.name, subfolders: builtin.folders.map({ $0.id }), vocab: builtin.vocab.map({ $0.id }))
        for folder in builtin.folders {
            FoldersDataManager.shared.saveFolder(folder)
        }
        for vocab in builtin.vocab {
            VocabDataManager.shared.saveVocab(vocab)
        }

        root.subfolders.append(file.id)
        FoldersDataManager.shared.saveFolder(file)
    }

    private static func loadDefaultFolder(named filename: String) -> DefaultFolder? {
        guard let path = Bundle.main.path(forResource: "DEFAULT_" + filename, ofType: "json") else { return nil }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONDecoder().decode(DefaultFolder.self, from: data)
            return jsonResult
        } catch {
            print("Oh no error: \(error)")
        }

        return nil
    }
}

struct DefaultFolder: Codable {
    var name: String
    var folders: [VocabFolder]
    var vocab: [Vocab]
}
