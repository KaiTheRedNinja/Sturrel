//
//  MainView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 22/10/23.
//

import SwiftUI

enum FolderOrVocabID: Identifiable, Hashable {
    case folder(UUID)
    case vocab(UUID)

    var id: UUID {
        switch self {
        case .folder(let uUID): uUID
        case .vocab(let uUID): uUID
        }
    }
}

class StartManager: ObservableObject {
    static let shared: StartManager = .init()

    private init() {}

    @Published var shown: Bool = false
}

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
