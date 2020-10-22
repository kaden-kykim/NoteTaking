//
//  NoteTakingModel.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import Foundation

class NoteTakingModel {
    
    static let instance = NoteTakingModel()
    
    static let noteSuffix = ".ntpkg"
    static let noteContentFileName = "contents.note"
    
    private static let rootName = "File Browser"
    private(set) var rootURL: URL!
    
    private let fileManager = FileManager.default
    
    private init() {
        do {
            let rootURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            self.rootURL = rootURL.appendingPathComponent(NoteTakingModel.rootName)
            if !fileManager.fileExists(atPath: rootURL.path) {
                try fileManager.createDirectory(at: rootURL, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            assertionFailure("Cannot initial NoteTaking App due to filesystem error")
        }
    }
    
}


// MARK: - Helper Methods
extension NoteTakingModel {
    
    func getContents(of url: URL) -> [URL] {
        guard let contents = try? fileManager.contentsOfDirectory(at: url,
                                                                  includingPropertiesForKeys: nil,
                                                                  options: .skipsHiddenFiles) else { return [] }
        return contents.filter(isDirectory(_:))
    }
    
    func getAttribute(of url: URL) -> [FileAttributeKey: Any]? {
        return try? fileManager.attributesOfItem(atPath: url.path)
    }
    
    @discardableResult
    func createDirectory(_ name: String, in url: URL, of type: PathComponent.CType) throws -> URL {
        let isNote = type == .note
        if !isNote && name.hasSuffix(NoteTakingModel.noteSuffix) { throw CreateError.DirectoryHasNoteSuffix }
        let newDirURL = url.appendingPathComponent(isNote ? name + NoteTakingModel.noteSuffix : name)
        if exist(newDirURL) { throw CreateError.AlreadyExist }
        do {
            try fileManager.createDirectory(at: newDirURL, withIntermediateDirectories: true, attributes: nil)
            if isNote {
                createNoteContentFile(at: newDirURL.appendingPathComponent(NoteTakingModel.noteContentFileName))
            }
        } catch {
            throw CreateError.System
        }
        return newDirURL
    }
    
    func deleteDirectory(at url: URL) -> Bool {
        do { try fileManager.removeItem(at: url) } catch { return false }
        return true
    }
    
    @discardableResult
    func createNoteContentFile(at url: URL) -> URL {
        let contentURL = url.appendingPathComponent(NoteTakingModel.noteContentFileName)
        if !exist(contentURL) {
            fileManager.createFile(atPath: contentURL.path, contents: nil, attributes: nil)
        }
        return contentURL
    }
    
    private func exist(_ url: URL) -> Bool {
        return fileManager.fileExists(atPath: url.path)
    }
    
    private func isDirectory(_ url: URL) -> Bool {
        var isDir: ObjCBool = false
        if !fileManager.fileExists(atPath: url.path, isDirectory: &isDir) { return false }
        return isDir.boolValue
    }
    
}
