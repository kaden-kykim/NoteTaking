//
//  PathComponent.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import Foundation

struct PathComponent {
    
    enum CType: String {
        case directory = "Directory"
        case note = "Note"
    }
    
    let type: PathComponent.CType
    let name: String
    let pathName: String
    var date: Date
    var extraInfo: Double
    
    init(type: PathComponent.CType, name: String, date: Date = Date(), extraInfo: Double = 0) {
        self.type = type
        self.date = date
        self.extraInfo = extraInfo
        if type == .note {
            self.name = name.hasSuffix(NoteTakingModel.noteSuffix)
                ? String(name.prefix(name.count - NoteTakingModel.noteSuffix.count)) : name
            self.pathName = self.name.appending(NoteTakingModel.noteSuffix)
        } else {
            self.name = name
            self.pathName = name
        }
    }
    
}
