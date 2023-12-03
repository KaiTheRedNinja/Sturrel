//
//  StartView.swift
//  Sturrel
//
//  Created by Kai Quan Tay on 27/10/23.
//

import SwiftUI

struct StartView: View {
    @State var includedFolders: Set<String> = Set(Root.manifest.builtins)

    @State var isLoading: Bool = false
    @State var loaded: Int = 0

    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    Text("Welcome to Sturrel")
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }

            vocabSelect

            Section {
                HStack {
                    Spacer()
                    Button("Finish") {
                        load()
                    }
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
                .listRowBackground(Color.clear)
                .disabled(isLoading)

                if isLoading {
                    ProgressView(value: Double(loaded), total: Double(includedFolders.count))
                        .listRowBackground(Color.clear)
                }
            }
        }
    }

    @ViewBuilder
    var vocabSelect: some View {
        Section {
            Text("""
Please select the vocabulary you would like to include.

Sturrel comes with Primary 1-6 and Secondary 1-3 vocabulary.

You can always add other builtin vocabulary by pressing the plus button in the Vocab view
""")
            .foregroundStyle(Color.gray)
            .listRowBackground(Color.clear)
        }

        Section {
            ForEach(Root.manifest.builtins, id: \.self) { element in
                Toggle(element, isOn: .init(get: {
                    includedFolders.contains(element)
                }, set: { isIncluded in
                    if isIncluded {
                        includedFolders.insert(element)
                    } else {
                        includedFolders.remove(element)
                    }
                }))
            }
        }
    }

    func load() {
        isLoading = true

        // remove all elements in FoldersDataManager
        FoldersDataManager.shared.removeAll()
        // reset Root
        try? Root.load()
        guard var root = FoldersDataManager.shared.getFolder(for: Root.id) else { return }
        root.subfolders = []
        FoldersDataManager.shared.saveFolder(root)

        for folder in Root.manifest.builtins where includedFolders.contains(folder) {
            Root.copyBuiltinFolder(named: folder)
            withAnimation {
                loaded += 1
            }
        }

        withAnimation {
            StartManager.shared.shown = false
        }
    }
}

#Preview {
    NavigationStack {
        StartView()
    }
}
