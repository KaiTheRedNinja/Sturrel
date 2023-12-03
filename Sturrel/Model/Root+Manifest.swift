//
//  Root+Manifest.swift
//  Sturrel
//
//  Created by Kai Quan Tay on 3/12/23.
//

import Foundation

extension Root {
    internal static func getManifest() -> Manifest {
        FileSystem.read(Manifest.self, from: .manifest) ?? getBundleManifest()
    }

    private static func getBundleManifest() -> Manifest {
        guard let path = Bundle.main.path(forResource: "manifest", ofType: "json") else {
            fatalError("Could not get manifest")
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONDecoder().decode(Manifest.self, from: data)
            return jsonResult
        } catch {
            fatalError("\(error)")
        }
    }

    /// Compares the current manifest to the bundle manifest, identifying differences
    static func checkManifest() -> [ManifestChange] {
        let currentManifest = Self.manifest
        let bundleManifest = getBundleManifest()
        var changes = [ManifestChange]()

        // check for added
        changes.append(
            contentsOf: bundleManifest.builtins
                .filter { !currentManifest.builtins.contains($0) }
                .map { ManifestChange.added($0) }
        )
        // check for removed
        changes.append(
            contentsOf: currentManifest.builtins
                .filter { !bundleManifest.builtins.contains($0) }
                .map { ManifestChange.removed($0) }
        )
        // check for updated
        changes.append(
            contentsOf: currentManifest.builtins
                .filter {
                    currentManifest.builtins.contains($0) &&
                    currentManifest.entries[$0]! < bundleManifest.entries[$0]!
                }
                .map {
                    ManifestChange.updated($0)
                }
        )

        return changes
    }

    static func resetManifest() {
        self.manifest = getBundleManifest()
    }

    // TODO: get the difference between the builtins
}

struct Manifest: Codable {
    typealias Version = UInt8

    var builtins: [String]
    var entries: [String: Version]

    init(builtins: [String], entries: [String : Version]) {
        self.builtins = builtins
        self.entries = entries
        assert(entries.count == builtins.count, "builtins and entries must contain the same number of items")
        assert(entries.keys.contains(builtins), "all builtins must have entries keys")
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.builtins = try container.decode([String].self, forKey: .builtins)
        self.entries = try container.decode([String : Manifest.Version].self, forKey: .entries)
        assert(entries.count == builtins.count, "builtins and entries must contain the same number of items")
        assert(entries.keys.contains(builtins), "all builtins must have entries keys")
    }
}

enum ManifestChange {
    case added(String)
    case updated(String)
    case removed(String)
}
