//
//  NewFolderView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 21/10/23.
//

import SwiftUI

struct NewFolderView: View {
    @Binding var folder: VocabFolder
    @State var prototypeNewFolder: VocabFolder

    @Environment(\.presentationMode) var presentationMode

    init(folder: Binding<VocabFolder>) {
        self._folder = folder
        
        var name = "New Folder"
        if folder.wrappedValue.subfolders.contains(where: { $0.name == name }) {
            var counter = 2
            while folder.wrappedValue.subfolders.contains(where: { $0.name == "\(name) \(counter)" }) {
                counter += 1
            }
            name += " \(counter)"
        }
        self._prototypeNewFolder = .init(initialValue: .init(name: name, subfolders: [], vocab: []))
    }

    var body: some View {
        NavigationStack {
            FolderListView(folder: $prototypeNewFolder)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                .environment(\.editMode, .init(get: { .active }, set: { newMode in
                    if newMode == .inactive {
                        folder.subfolders.append(prototypeNewFolder)
                        presentationMode.wrappedValue.dismiss()
                    }
                }))
        }
    }
}
