//
//  NoteCoordinator.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import UIKit

class NoteCoordinatorImpl: Coordinator {
    
    unowned let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, fileURL: URL) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = NoteViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
