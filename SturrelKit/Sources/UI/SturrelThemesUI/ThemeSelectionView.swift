//
//  ThemeSelectionView.swift
//  Sturrel
//
//  Created by Kai Quan Tay on 5/12/23.
//

import SwiftUI
import SturrelThemes

public struct ThemeSelectionView: View {
    @ObservedObject var themeManager: ThemeManager = .shared

    public var body: some View {
        ForEach(themeManager.builtinThemes) { theme in
            Button {
                themeManager.currentTheme = theme
            } label: {
                HStack {
                    viewForTheme(theme: theme)
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color.detail)
                        .opacity(theme == themeManager.currentTheme ? 1 : 0)
                        .bold()
                        .padding(.leading, 10)
                }
            }
            .listRowBackground(Color.primary.colorInvert())
        }
    }

    func viewForTheme(theme: SturrelTheme) -> some View {
        HStack {
            Text(theme.name)
                .foregroundStyle(Color.foreground)
            Spacer()
            ForEach(Array(theme.colors.enumerated()), id: \.offset) { (_, color) in
                Circle()
                    .fill(color)
                    .frame(width: 15, height: 15)
                    .padding(-1)
                    .background {
                        Circle()
                            .fill(Color.white)
                    }
            }
        }
    }
}

#Preview {
    List {
        ThemeSelectionView()
    }
}
