//
//  NewFolderView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 21/10/23.
//

import SwiftUI

struct NewFolderView: View {
    @Binding var folder: VocabFolder
    @Binding var prototypeNewFolder: VocabFolder?

    var body: some View {
        NavigationStack {
            FolderListView(
                folder: .init(
                    get: {
                        prototypeNewFolder!
                    },
                    set: { newValue in
                        prototypeNewFolder = newValue
                    }
                )
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        prototypeNewFolder = nil
                    }
                }
            }
            .environment(\.editMode, .init(get: { .active }, set: { newMode in
                if newMode == .inactive {
                    folder.subfolders.append(prototypeNewFolder!)
                    prototypeNewFolder = nil
                }
            }))
        }
    }
}
