//
//  FileSystem.swift
//  ChineseWordSearchTest
//
//  Created by Kai Quan Tay on 20/10/23.
//

import Foundation

public enum FileSystem {
    public static var currentUserEmail: String?

    public enum FileName {
        case root
        case vocabs
        case customFolder(UUID)

        public var fileName: String {
            switch self {
            case .root: "root.json"
            case .vocabs: "vocabs.json"
            case .customFolder(let id): "custom/CUSTOM_\(id.uuidString).json"
            }
        }
    }

    /// Reads a type from a file
    public static func read<T: Decodable>(_ type: T.Type, from file: FileName) -> T? {
        let filename = getDocumentsDirectory().appendingPathComponent(file.fileName)
        if let data = try? Data(contentsOf: filename) {
            if let values = try? JSONDecoder().decode(T.self, from: data) {
                return values
            }
        }

        return nil
    }

    /// Writes a type to a file
    public static func write<T: Encodable>(_ value: T, to file: FileName, error onError: @escaping (Error) -> Void = { _ in }) {
        var encoded: Data

        do {
            encoded = try JSONEncoder().encode(value)
        } catch {
            onError(error)
            return
        }

        let filename = getDocumentsDirectory().appendingPathComponent(file.fileName)
        if file.fileName.contains("/") {
            try? FileManager.default.createDirectory(atPath: filename.deletingLastPathComponent().path,
                                                     withIntermediateDirectories: true,
                                                     attributes: nil)
        }
        do {
            try encoded.write(to: filename)
            return
        } catch {
            // failed to write file – bad permissions, bad filename,
            // missing permissions, or more likely it can't be converted to the encoding
            onError(error)
        }
    }

    /// Checks if a file exists at a path
    public static func exists(file: FileName) -> Bool {
        let path = getDocumentsDirectory().appendingPathComponent(file.fileName)
        return FileManager.default.fileExists(atPath: path.relativePath)
    }

    /// Returns the URL of the path
    public static func path(file: FileName) -> URL {
        getDocumentsDirectory().appendingPathComponent(file.fileName)
    }

    /// Gets the documents directory
    public static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

public extension URL {
    /// The attributes of a url
    var attributes: [FileAttributeKey: Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }

    /// The file size of the url
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }

    /// The file size of the url as a string
    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }

    /// The date of creation of the file
    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}
