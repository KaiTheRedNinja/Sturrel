//
//  SettingsView.swift
//  Sturrel
//
//  Created by Kai Quan Tay on 28/10/23.
//

import SwiftUI

struct SettingsView: View {
    @State var showResetConfirm: Bool = false

    var body: some View {
        ThemedList {
            Section {
                Button("Reset All Vocab", role: .destructive) {
                    showResetConfirm = true
                }
                .alert("Are you sure you want to reset all vocabulary?", isPresented: $showResetConfirm) {
                    Button("Confirm", role: .destructive) {
                        reset()
                    }

                    Button("Cancel", role: .cancel) {
                        // do nothing
                    }
                } message: {
                    Text("This action cannot be undone")
                }
                .bold()
                .listRowBackground(Color.primary.colorInvert())
            }

            Section("Theme") {
                ThemeSelectionView()
            }

            Section {
                NavigationLink {
                    ScrollView {
                        VStack(alignment: .center) {
                            VStack {
                                Text("Rewritten by Tay Kai Quan")
                                    .padding(.bottom, 10)
                                Text("Originally written and designed by:\nTay Kai Quan\nNatalie Ruzsicska\nElyssa Yeo\nZara Rosman")
                            }
                            .padding(.bottom, 60)

                            VStack {
                                Text("Vocabulary provided by\nXueLin Learning Hub")
                                Image("xuelinLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                            }
                        }
                        .foregroundStyle(Color.additional)
                        .listRowBackground(Color.clear)
                        .multilineTextAlignment(.center)
                    }
                } label: {
                    Text("Credits")
                }
            }
        }
        .navigationTitle("Settings")
    }

    func reset() {
        // remove all elements in FoldersDataManager
        FoldersDataManager.shared.removeAll()
        // remove all elements in VocabDatamanager
        VocabDataManager.shared.removeAll()
        // reset the manifest
        Root.resetManifest()
        // reset Root
        try? Root.load()
        guard var root = FoldersDataManager.shared.getFolder(for: Root.id) else { return }
        root.subfolders = []
        FoldersDataManager.shared.saveFolder(root)

        StartManager.shared.shown = true
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
