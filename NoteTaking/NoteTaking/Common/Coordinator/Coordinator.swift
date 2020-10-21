//
//  Coordinator.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import Foundation

protocol Coordinator: AnyObject {
    func start()
    func coordinate(to coordinator: Coordinator)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}
