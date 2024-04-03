//
//  ThemedList.swift
//  Sturrel
//
//  Created by Kai Quan Tay on 5/12/23.
//

import SwiftUI

public struct ThemedList<Content: View>: View {
    var content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        List {
            content()
                .listRowBackground(Color.listItem)
        }
        .themed()
    }
}

#Preview {
    ThemedList {
        Section("Test") {
            Text("HI")

            ForEach(0..<3) { index in
                Text("index \(index)")
            }
        }

        Section("NO") {
            Text("EEEE")
                .listRowBackground(Color.clear)
        }
    }
}
