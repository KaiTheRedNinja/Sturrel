//
//  StartManager.swift
//
//
//  Created by Kai Quan Tay on 3/4/24.
//

import Foundation

public class StartManager: ObservableObject {
    public static let shared: StartManager = .init()

    private init() {}

    @Published public var shown: Bool = false
    @Published public var changes: ManifestChangeReport?

    public struct ManifestChangeReport: Identifiable {
        public var id = UUID()
        public var changes: [ManifestChange]

        public init(id: UUID = UUID(), changes: [ManifestChange]) {
            self.id = id
            self.changes = changes
        }
    }
}
