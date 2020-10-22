//
//  NoteViewController.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import RxSwift

class NoteViewController: UIViewController {

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        bindOnNavigationBar()
        
        viewModel.viewDidLoad.accept(())
    }
    
    // MARK: - Properties
    var viewModel: NoteViewModel!
    private let disposeBag = DisposeBag()

}

// MARK: - Bindings
extension NoteViewController {
    
    private func bindOnNavigationBar() {
        viewModel.noteTitle
            .subscribe(onNext: { [weak self] title in
                DispatchQueue.main.async { self?.title = title }
            }).disposed(by: disposeBag)
    }
}


// MARK: - UI Setup
extension NoteViewController {
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
}
