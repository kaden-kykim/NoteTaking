//
//  NoteCoordinator.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import UIKit

class NoteCoordinatorImpl: Coordinator {
    
    unowned let navigationController: UINavigationController
    
    private let fileURL: URL
    
    init(navigationController: UINavigationController, fileURL: URL) {
        self.navigationController = navigationController
        self.fileURL = fileURL
    }
    
    func start() {
        let noteViewController = NoteViewController()
        noteViewController.viewModel = NoteViewModelImpl(coordinator: self, fileURL: fileURL)
        navigationController.pushViewController(noteViewController, animated: true)
    }
    
}
