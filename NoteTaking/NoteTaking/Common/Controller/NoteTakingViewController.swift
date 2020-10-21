//
//  NoteTakingViewController.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import UIKit

class NoteTakingViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileBrowserCoordinator = FileBrowserCoordinatorImpl(navigationController: self)
        fileBrowserCoordinator.start()
    }
    
}
