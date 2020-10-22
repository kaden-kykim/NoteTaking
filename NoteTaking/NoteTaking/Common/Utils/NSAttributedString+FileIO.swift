//
//  NSAttributedString+FileIO.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import Foundation

enum NoteFileIOError: Error {
    case FailToInitFromURL
    case FailToSaveNote
    case System
}

extension NSAttributedString {
    
    convenience init(from url: URL) throws {
        do {
            let data = try Data(contentsOf: .init(fileURLWithPath: url.path))
            try self.init(data: data, options: [.documentType: NSAttributedString.DocumentType.rtfd], documentAttributes: nil)
        } catch {
            self.init()
            throw NoteFileIOError.FailToInitFromURL
        }
    }
    
    func save(to url: URL) throws {
        do {
            let data = try self.data(from: .init(location: 0, length: length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd])
            try data.write(to: url, options: .atomic)
        } catch {
            throw NoteFileIOError.FailToSaveNote
        }
    }
    
}
