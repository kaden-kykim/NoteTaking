//
//  FileBrowserViewController.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import UIKit

class FileBrowserViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "File Browser"
        view.backgroundColor = .systemBackground
        
        testNavigation()
    }
    
    
    
    // MARK: - Start: Test for navigation
    var coordinator: FileBrowserCoordinatorImpl!
    
    private func testNavigation() {
        // for browser self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Browser", style: .plain, target: self, action: #selector(moveToFileBrowser(_:)))
        
        // for note
        let noteButton = UIButton()
        noteButton.setTitle("Push to Note", for: .normal)
        noteButton.setTitleColor(.label, for: .normal)
        noteButton.addTarget(self, action: #selector(moveToNote(_:)), for: .touchUpInside)
        view.addSubview(noteButton)
        noteButton.matchParent()
    }
    
    @objc func moveToFileBrowser(_ sender: UIButton) {
        coordinator.push()
    }
    
    @objc func moveToNote(_ sender: UIButton) {
        coordinator.push(to: URL(string: "dummy"), isNote: true)
    }
    // MARK: - End: Test for navigation
    
}
