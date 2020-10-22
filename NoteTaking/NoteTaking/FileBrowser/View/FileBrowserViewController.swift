//
//  FileBrowserViewController.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import RxSwift

class FileBrowserViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "File Browser"
        view.backgroundColor = .systemBackground
        
        testNavigation()
    }
    
    // MARK: - Properties
    var viewModel: FileBrowserViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - Start: Test for navigation
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
        self.viewModel.pushTo.accept((URL(string: "browser")!, false))
    }
    
    @objc func moveToNote(_ sender: UIButton) {
        self.viewModel.pushTo.accept((URL(string: "note")!, true))
    }
    // MARK: - End: Test for navigation
    
}
