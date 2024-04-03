//
//  SturrelTheme.swift
//  
//
//  Created by Kai Quan Tay on 3/4/24.
//

import SwiftUI

public struct SturrelTheme: Identifiable, Codable, Hashable {
    public var id = UUID()

    public var name: String

    public var backgroundColor: Color
    public var listItemColor: Color
    public var foregroundColor: Color
    public var detailColor: Color

    public var colors: [Color] {
        [
            backgroundColor,
            listItemColor,
            foregroundColor,
            detailColor
        ]
    }
}
