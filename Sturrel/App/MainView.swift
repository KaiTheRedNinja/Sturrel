//
//  MainView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 22/10/23.
//

import SwiftUI
import SturrelTypes
import SturrelVocab
import SturrelVocabUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            VStack {
                FolderListView(folderID: Root.id, isTopLevel: true)
            }
            .navigationDestination(for: FolderOrVocabID.self) { item in
                switch item {
                case .folder(let id): FolderListView(folderID: id)
                case .vocab(let id): VocabDetailsView(vocabID: id)
                }
            }
        }
    }
}

#Preview {
    MainView()
}
