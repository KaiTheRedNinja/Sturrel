//
//  ThemeColor.swift
//
//
//  Created by Kai Quan Tay on 3/4/24.
//

import SwiftUI

public struct ThemeColor: View, ShapeStyle {
    @ObservedObject public var themeManager: ThemeManager = .shared

    public var role: Role

    public enum Role {
        case backgroundColor, listItemColor, foregroundColor, detailColor, additionalColor
    }

    public var body: Color {
        color
    }

    public func resolve(in environment: EnvironmentValues) -> Color {
        color
    }

    public var color: Color {
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

    public static let background = ThemeColor(role: .backgroundColor)
    public static let listItem = ThemeColor(role: .listItemColor)
    public static let foreground = ThemeColor(role: .foregroundColor)
    public static let detail = ThemeColor(role: .detailColor)
    public static let additional = ThemeColor(role: .additionalColor)
}

public extension Color {
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

