//
//  FileBrowserCoordinator.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import UIKit

protocol FileBrowserCoordinator: AnyObject {
    func push(to url: URL?, isNote: Bool)
}

class FileBrowserCoordinatorImpl: Coordinator {
    
    unowned let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { push() }
    
}

extension FileBrowserCoordinatorImpl: FileBrowserCoordinator {
    
    func push(to url: URL? = nil, isNote: Bool = false) {
        if isNote {
            if let url = url {
                NoteCoordinatorImpl(navigationController: navigationController, fileURL: url).start()
            }
        } else {
            let fileBrowserViewController = FileBrowserViewController()
            fileBrowserViewController.viewModel = FileBrowserViewModelImpl(coordinator: self, url: url ?? NoteTakingModel.instance.rootURL)
            navigationController.pushViewController(fileBrowserViewController, animated: true)
        }
    }
    
}
