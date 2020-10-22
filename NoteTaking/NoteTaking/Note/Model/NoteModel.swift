//
//  NoteModel.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import Foundation

struct NoteModel {
    private let globalModel = NoteTakingModel.instance
    private let url: URL
    let name: String
    
    init (url: URL) {
        self.url = url
        let pathComponent = url.lastPathComponent
        self.name = String(pathComponent.prefix(pathComponent.count - NoteTakingModel.noteSuffix.count))
    }
}
