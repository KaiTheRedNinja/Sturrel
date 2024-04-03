//
//  NewFolderView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 21/10/23.
//

import SwiftUI
import SturrelTypes
import SturrelModel

struct NewFolderView: View {
    var targetFolderID: VocabFolder.ID
    @State var prototypeNewFolderID: VocabFolder.ID!

    @ObservedObject var folderDataManager: FoldersDataManager = .shared

    @Environment(\.presentationMode) var presentationMode

    init(targetFolderID: VocabFolder.ID) {
        self.targetFolderID = targetFolderID
    }

    var body: some View {
        NavigationStack {
            if let prototypeNewFolderID {
                FolderListView(folderID: prototypeNewFolderID)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel") {
                                FoldersDataManager.shared.removeFolder(prototypeNewFolderID)
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                    .environment(\.editMode, .init(get: { .active }, set: { newMode in
                        if newMode == .inactive {
                            FoldersDataManager.shared.bindingFolder(for: targetFolderID).wrappedValue.subfolders.append(prototypeNewFolderID)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }))
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            var name = "New Folder"

            if let subfolders = FoldersDataManager.shared.getFolder(for: targetFolderID)?.subfolders {
                if subfolders.contains(where: { FoldersDataManager.shared.getFolder(for: $0)?.name == name }) {
                    var counter = 2
                    while subfolders.contains(where: { FoldersDataManager.shared.getFolder(for: $0)?.name == "\(name) \(counter)" }) {
                        counter += 1
                    }
                    name += " \(counter)"
                }
            }

            let prototype = VocabFolder(name: name, subfolders: [], vocab: [])

            FoldersDataManager.shared.saveFolder(prototype)
            self.prototypeNewFolderID = prototype.id
        }
    }
}
