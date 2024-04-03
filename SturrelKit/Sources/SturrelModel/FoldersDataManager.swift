//
//  FoldersDataManager.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 22/10/23.
//

import SwiftUI
import SturrelTypes

public final class FoldersDataManager: ObservableObject {
    public static var shared: FoldersDataManager = .init()

    private init() {}

    @Published private var folders: [VocabFolder.ID: VocabFolder] = [:]

    public func getFolder(for id: VocabFolder.ID) -> VocabFolder? {
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

    public func saveFolder(_ folder: VocabFolder) {
        folders[folder.id] = folder

        if folder.id == Root.id {
            Root.save()
        } else {
            FileSystem.write(folder, to: .customFolder(folder.id))
        }
    }

    public func removeFolder(_ id: VocabFolder.ID) {
        folders.removeValue(forKey: id)
        FileSystem.remove(file: .customFolder(id))
    }

    /// Creates a binding to a folder. The binding will create the folder if needed.
    public func bindingFolder(for id: VocabFolder.ID) -> Binding<VocabFolder> {
        return .init {
            self.getFolder(for: id) ?? .init(id: id, name: "Folder", subfolders: [], vocab: [])
        } set: { newValue in
            self.saveFolder(newValue)
        }
    }

    public func save() {
        for (id, folder) in folders where id != Root.id {
            FileSystem.write(folder, to: .customFolder(id))
        }
    }

    public func removeAll() {
        for folder in folders.keys {
            removeFolder(folder)
        }
    }

    private func loadCustomFolder(id: UUID) -> VocabFolder? {
        guard let result = FileSystem.read(VocabFolder.self, from: .customFolder(id)) else { return nil }
        return result
    }
}
