//
//  FileBrowserModel.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import Foundation

class FileBrowserModel {
    
    static let instance = FileBrowserModel()

    private static let rootName = "File Browser"
    private(set) var rootURL: URL!
    
    private let fileManager = FileManager.default
    
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
    
}
