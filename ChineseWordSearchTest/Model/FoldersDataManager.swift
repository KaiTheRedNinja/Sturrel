//
//  FoldersDataManager.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 22/10/23.
//

import SwiftUI

final class FoldersDataManager: ObservableObject {
    static var shared: FoldersDataManager = .init()

    private init() {}

    @Published private var folders: [VocabFolder.ID: VocabFolder] = [:]

    func getFolder(for id: VocabFolder.ID) -> VocabFolder? {
        if id == RootDataManager.shared.root.id {
            return RootDataManager.shared.root
        }

        if let folder = self.folders[id] {
            return folder
        } else if let folder = self.loadCustomFolder(id: id) {
            DispatchQueue.main.async {
                self.folders[id] = folder
            }
            return folder
        }
        return nil
    }

    func saveFolder(_ folder: VocabFolder) {
        if folder.id == RootDataManager.shared.root.id {
            RootDataManager.shared.root = folder
            RootDataManager.shared.save()
            return
        }

        folders[folder.id] = folder

        FileSystem.write(folder, to: .customFolder(folder.id))
    }

    func removeFolder(_ id: VocabFolder.ID) {
        folders.removeValue(forKey: id)
        FileSystem.remove(file: .customFolder(id))
    }

    /// Creates a binding to a folder. The binding will create the folder if needed.
    func bindingFolder(for id: VocabFolder.ID) -> Binding<VocabFolder> {
        return .init {
            self.getFolder(for: id) ?? .init(id: id, name: "Folder", subfolders: [], vocab: [])
        } set: { newValue in
            self.saveFolder(newValue)
        }
    }

    func save() {
        for (id, folder) in folders {
            FileSystem.write(folder, to: .customFolder(id))
        }
    }

    private func loadCustomFolder(id: UUID) -> VocabFolder? {
        guard let result = FileSystem.read(VocabFolder.self, from: .customFolder(id)) else { return nil }
        return result
    }
}
