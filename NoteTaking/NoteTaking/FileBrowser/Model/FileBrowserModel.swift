//
//  FileBrowserModel.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import Foundation

enum CreateError: Error {
    case DirectoryHasNoteSuffix, AlreadyExist, System
}

struct FileBrowserModel {
    private let globalModel = NoteTakingModel.instance
    private let url: URL
    let name: String
    
    init (url: URL) {
        self.url = url
        self.name = url.lastPathComponent
    }
}

// MARK: - FileBrowser Helper Methods
extension FileBrowserModel {
    
    func getPathComponents() -> [PathComponent] {
        let contents = globalModel.getContents(of: url)
        var dirComponents = [String](), noteComponents = [String]()
        for content in contents {
            if content.lastPathComponent.hasSuffix(NoteTakingModel.noteSuffix) {
                noteComponents.append(content.lastPathComponent)
            } else {
                dirComponents.append(content.lastPathComponent)
            }
        }
        dirComponents.sort(by: <)
        noteComponents.sort(by: <)
        var pathComponents = [PathComponent]()
        for component in dirComponents {
            let dirURL = url.appendingPathComponent(component)
            var pathComponent = PathComponent(type: .directory, name: component)
            if let attr = globalModel.getAttribute(of: dirURL), let date = attr[.modificationDate] as? Date { pathComponent.date = date }
            pathComponent.extraInfo = Double(globalModel.getContents(of: dirURL).count)
            pathComponents.append(pathComponent)
        }
        for component in noteComponents {
            let noteURL = url.appendingPathComponent(component)
            var noteComponent = PathComponent(type: .note, name: component)
            if let attr = globalModel.getAttribute(of: noteURL.appendingPathComponent(NoteTakingModel.noteContentFileName)),
               let date = attr[.modificationDate] as? Date { noteComponent.date = date }
            pathComponents.append(noteComponent)
            globalModel.createNoteContentFile(at: noteURL)
        }
        return pathComponents
    }
    
    func createDirectory(_ name: String, of type: PathComponent.CType) throws -> URL {
        do {
            return try globalModel.createDirectory(name, in: url, of: type)
        } catch let error as CreateError {
            throw error
        } catch {
            throw CreateError.System
        }
    }
    
    func deleteDirectory(_ pathComponent: PathComponent) {
        globalModel.deleteDirectory(at: url.appendingPathComponent(pathComponent.pathName))
    }
    
}
