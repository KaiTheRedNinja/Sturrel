//
//  BuiltinsUpdateView.swift
//  Sturrel
//
//  Created by Kai Quan Tay on 5/12/23.
//

import SwiftUI

struct BuiltinsUpdateView: View {
    @State var changes: [(ManifestChange, Bool)]

    var body: some View {
        ThemedList {
            Section {
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        Text("\(changes.count) Built-in folders have recieved updates")
                            .font(.title)
                            .padding(.bottom, 5)
                        Text("Select the folders you want to update")
                            .foregroundStyle(Color.additional)
                    }
                    Spacer()
                }
                .multilineTextAlignment(.center)
                .listRowBackground(Color.clear)
            }

            Section {
                ForEach($changes, id: \.wrappedValue.0.id) { $changePair in
                    viewForChange(change: changePair.0, enabled: $changePair.1)
                }
            }

            Section {
                HStack {
                    Spacer()
                    Button("Update") {
                        update()
                    }
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                HStack {
                    Spacer()
                    Text("This will replace the selected folders with the updated versions. Any manual changes inside those folders will be lost.")
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
    }

    func viewForChange(change: ManifestChange, enabled: Binding<Bool>) -> some View {
        VStack {
            Toggle(change.description, isOn: enabled)
        }
    }

    func update() {
        // update the selected
        for (change, enabled) in changes where enabled {
            switch change {
            case .added, .updated:
                Root.copyBuiltinFolder(named: change.folder)
            case .removed(let string):
                guard var root = FoldersDataManager.shared.getFolder(for: Root.id),
                      let matchingFolder = root.subfolders.first(where: { FoldersDataManager.shared.getFolder(for: $0)?.name == string }) else {
                    print("Could not get folder to remove: \(string)")
                    continue
                }
                root.subfolders.removeAll(where: { $0 == matchingFolder })
                FoldersDataManager.shared.saveFolder(root)
                FoldersDataManager.shared.removeFolder(matchingFolder)
            }
        }

        // update the manifest
        Root.resetManifest()

        StartManager.shared.changes = nil
    }
}

#Preview {
    BuiltinsUpdateView(changes: [])
}
