//
//  NoteModel.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import Foundation

enum NoteFontStyle: Int, CaseIterable, CustomStringConvertible {
    case bold = 0, italic = 1, underline = 2, strikethrough = 3
    
    var description: String {
        switch self {
        case .bold: return "bold"
        case .italic: return "italic"
        case .underline: return "underline"
        case .strikethrough: return "strikethrough"
        }
    }
}

struct NoteModel {
    private let globalModel = NoteTakingModel.instance
    private let url: URL
    private let contentURL: URL
    let name: String
    
    init (url: URL) {
        self.url = url
        self.contentURL = globalModel.getNoteContentURL(at: url)
        let pathComponent = url.lastPathComponent
        self.name = String(pathComponent.prefix(pathComponent.count - NoteTakingModel.noteSuffix.count))
    }
}

extension NoteModel {
    
    func loadNote() throws -> NSAttributedString {
        do {
            return try NSAttributedString.init(from: contentURL)
        } catch {
            throw error
        }
    }
    
    func saveNote(_ attributedString: NSAttributedString) throws {
        try attributedString.save(to: contentURL)
    }
    
}
