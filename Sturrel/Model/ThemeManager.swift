//
//  ThemeManager.swift
//  Sturrel
//
//  Created by Kai Quan Tay on 5/12/23.
//

import SwiftUI

struct SturrelTheme: Identifiable, Codable, Hashable {
    var id = UUID()

    var name: String

    var backgroundColor: Color
    var listItemColor: Color
    var foregroundColor: Color
    var detailColor: Color

    var colors: [Color] {
        [
            backgroundColor,
            listItemColor,
            foregroundColor,
            detailColor
        ]
    }
}

class ThemeManager: ObservableObject {
    @Published var currentTheme: SturrelTheme {
        didSet {
            DispatchQueue.main.async { [weak self] in
                UserDefaults.standard.setValue(self?.currentTheme.id.uuidString, forKey: "current_theme")
            }
        }
    }

    var builtinThemes: [SturrelTheme] = [
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
        )
        // TODO: Forest
        // TODO: Beach
    ]

    static let shared: ThemeManager = .init()
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

struct ThemeModifier: ViewModifier {
    func body(content: Content) -> some View {
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

extension View {
    func themed() -> some View {
        self.modifier(ThemeModifier())
    }
}

struct ThemeColor: View, ShapeStyle {
    @ObservedObject var themeManager: ThemeManager = .shared

    var role: Role

    enum Role {
        case backgroundColor, listItemColor, foregroundColor, detailColor, additionalColor
    }

    var body: Color {
        color
    }

    func resolve(in environment: EnvironmentValues) -> Color {
        color
    }

    var color: Color {
        switch role {
        case .backgroundColor:
            themeManager.currentTheme.backgroundColor
        case .listItemColor:
            themeManager.currentTheme.listItemColor
        case .foregroundColor:
            themeManager.currentTheme.foregroundColor
        case .detailColor:
            themeManager.currentTheme.detailColor
        case .additionalColor:
            themeManager.currentTheme.foregroundColor.opacity(0.8)
        }
    }

    static let background = ThemeColor(role: .backgroundColor)
    static let listItem = ThemeColor(role: .listItemColor)
    static let foreground = ThemeColor(role: .foregroundColor)
    static let detail = ThemeColor(role: .detailColor)
    static let additional = ThemeColor(role: .additionalColor)
}

extension Color {
    static let background = ThemeColor.background
    static let listItem = ThemeColor.listItem
    static let foreground = ThemeColor.foreground
    static let detail = ThemeColor.detail
    static let additional = ThemeColor.additional
}

extension Color: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rgba = try container.decode(RGBA.self)

        self.init(.sRGB, red: Double(rgba.r), green: Double(rgba.g), blue: Double(rgba.b), opacity: Double(rgba.a))
    }

    public func encode(to encoder: Encoder) throws {
        guard let components = cgColor?.components, components.count >= 3 else { return }
        var container = encoder.singleValueContainer()

        try container.encode(RGBA(r: Float(components[0]), g: Float(components[1]), b: Float(components[2]),
            a: (components.count >= 4) ? Float(components[3]) : Float(1.0)
        ))
    }

    struct RGBA: Codable { var r, g, b, a: Float }
}
