//
//  MainView.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 22/10/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            VStack {
                FolderListView(folderID: Root.id)
            }
        }
    }
}

#Preview {
    MainView()
}
