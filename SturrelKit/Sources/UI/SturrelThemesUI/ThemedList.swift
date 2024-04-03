//
//  ThemedList.swift
//  Sturrel
//
//  Created by Kai Quan Tay on 5/12/23.
//

import SwiftUI

public struct ThemedList<Content: View>: View {
    var content: () -> Content

    public init(
        scroll: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
    }

    public var body: some View {
        list
            .background {
                Color(uiColor: .systemGroupedBackground)
                    .overlay(alignment: .top) {
                        Color.background
                            .saturation(2.0)
                            .opacity(0.5)
                            .mask(
                                LinearGradient(
                                    colors: [
                                        Color.white,
                                        Color.clear
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: UIScreen.main.bounds.height / 2)
                    }
                    .ignoresSafeArea(.all)
            }
            .scrollContentBackground(.hidden)
            .toolbarBackground(Color.background.opacity(0.9), for: .navigationBar, .tabBar)
            .tint(Color.detail)
    }

    @ViewBuilder
    var list: some View {
        List {
            content()
                .listRowBackground(Color.listItem)
        }
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
