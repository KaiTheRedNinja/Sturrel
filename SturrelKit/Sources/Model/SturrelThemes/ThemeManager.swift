//
//  ThemeManager.swift
//  Sturrel
//
//  Created by Kai Quan Tay on 5/12/23.
//

import SwiftUI
import SturrelTypes

public class ThemeManager: ObservableObject {
    @Published public var currentTheme: SturrelTheme {
        didSet {
            DispatchQueue.main.async { [weak self] in
                UserDefaults.standard.setValue(self?.currentTheme.id.uuidString, forKey: "current_theme")
            }
        }
    }

    public var builtinThemes: [SturrelTheme] = [
        .init(
            id: UUID(uuidString: "E7FBE9AA-C413-4AD1-83DE-E19B84C579AA")!,
            name: "iOS Native",
            backgroundColor: .init(uiColor: .systemGroupedBackground),
            listItemColor: .init(uiColor: .systemBackground),
            foregroundColor: .primary,
            detailColor: .purple
        ),
        .init(
            id: UUID(uuidString: "4DF429C1-3293-4459-8ADE-6A4EB4933253")!,
            name: "Tico",
            backgroundColor: .purple.opacity(0.2),
            listItemColor: .pink.opacity(0.1),
            foregroundColor: .primary,
            detailColor: .yellow
        ),
        .init(
            id: UUID(uuidString: "2D7956DF-18C3-43FC-8F9A-5AE329004536")!,
            name: "Forest",
            backgroundColor: .green.opacity(0.2),
            listItemColor: .green.opacity(0.6),
            foregroundColor: .primary,
            detailColor: .brown
        ),
        .init(
            id: UUID(uuidString: "FAF0C735-363B-4658-8148-FDD701FD8D80")!,
            name: "Beach",
            backgroundColor: .yellow.opacity(0.3),
            listItemColor: .blue.opacity(0.3),
            foregroundColor: .blue,
            detailColor: .indigo
        )
    ]

    public static let shared: ThemeManager = .init()
    private init() {
//        guard let path = Bundle.main.path(forResource: "defaultThemes", ofType: "json") else { fatalError("No themes found") }
//        do {
//            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//            let jsonResult = try JSONDecoder().decode([SturrelTheme].self, from: data)
//            self.builtinThemes = jsonResult
//        } catch {
//            fatalError("\(error)")
//        }

        // TODO: user-created themes

        // set the current theme
        if let currentThemeID = UserDefaults.standard.string(forKey: "current_theme"),
           let matchingTheme = builtinThemes.first(where: { $0.id.uuidString == currentThemeID }) {
            self.currentTheme = matchingTheme
        } else {
            self.currentTheme = builtinThemes.first!
        }
    }
}
