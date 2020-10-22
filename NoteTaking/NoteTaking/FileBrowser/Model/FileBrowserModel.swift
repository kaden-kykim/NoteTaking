//
//  FileBrowserModel.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import Foundation

enum PathComponentType: String {
    case directory = "Directory"
    case note = "Note"
}

struct PathComponent {
    let type: PathComponentType
    var name: String
    var date: Date = Date()
    var extraInfo: Double = 0
}

class FileBrowserModel {
    
    static let instance = FileBrowserModel()

    private static let rootName = "File Browser"
    private(set) var rootURL: URL!
    
    private let fileManager = FileManager.default
    private let noteSuffix = ".ntpkg"
    private let noteContentFileName = "contents.note"
    
    private init() {
        do {
            let rootURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            self.rootURL = rootURL.appendingPathComponent(FileBrowserModel.rootName)
            if !fileManager.fileExists(atPath: rootURL.path) {
                try fileManager.createDirectory(at: rootURL, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            assertionFailure("Cannot initial NoteTaking App due to filesystem error")
        }
    }
    
    func getPathComponents(_ url: URL) -> [PathComponent] {
        // MARK: return dummy data for test
        return [PathComponent(type: .directory, name: "Dir1"),
                PathComponent(type: .directory, name: "Dir2"),
                PathComponent(type: .directory, name: "Dir3"),
                PathComponent(type: .directory, name: "Dir4"),
                PathComponent(type: .directory, name: "Dir5"),
                PathComponent(type: .directory, name: "Dir6"),
                PathComponent(type: .note, name: "note1"),
                PathComponent(type: .note, name: "note2"),
                PathComponent(type: .note, name: "note3"),
                PathComponent(type: .note, name: "note4"),
                PathComponent(type: .note, name: "note5"),
                PathComponent(type: .note, name: "note6"),
                PathComponent(type: .note, name: "note7")]
    }
    
}
