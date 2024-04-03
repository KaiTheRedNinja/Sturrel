//
//  ThemeModifier.swift
//
//
//  Created by Kai Quan Tay on 3/4/24.
//

import SwiftUI

public struct ThemeModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .background {
                Color.background
                    .ignoresSafeArea(.all)
            }
            .scrollContentBackground(.hidden)
            .toolbarBackground(.visible, for: .navigationBar, .tabBar)
            .toolbarBackground(Color.background.opacity(0.9), for: .navigationBar, .tabBar)
            .tint(Color.detail)
        //            .foregroundStyle(Color.foreground)
    }
}

public extension View {
    func themed() -> some View {
        self.modifier(ThemeModifier())
    }
}
