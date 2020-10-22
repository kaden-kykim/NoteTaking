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

        setupUI()
        
        bindOnNavigationBar()
        bindOnToolbar()
        
        viewModel.viewDidLoad.accept(())
    }
    
    // MARK: - Properties
    var viewModel: FileBrowserViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties (UI)
    private static let toolbarHeight: CGFloat = 44
    private lazy var newDirectoryBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "folder.badge.plus"), style: .plain, target: nil, action: nil)
    private lazy var newNoteBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "square.and.pencil"), style: .plain, target: nil, action: nil)
    
}

// MARK: - Bindings
extension FileBrowserViewController {
    
    private func bindOnNavigationBar() {
        viewModel.pathTitle
            .subscribe(onNext: { [weak self] title in
                DispatchQueue.main.async { self?.title = title }
            }).disposed(by: disposeBag)
    }
    
    private func bindOnToolbar() {
        newDirectoryBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                // MARK: - Test for navigation
                self?.viewModel.pushTo.accept((URL(string: "browser")!, false))
            }).disposed(by: disposeBag)

        
        newNoteBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                // MARK: - Test for navigation
                self?.viewModel.pushTo.accept((URL(string: "note")!, true))
            }).disposed(by: disposeBag)
    }
    
}

// MARK: - UI Setup
extension FileBrowserViewController {
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        setupUIToolbar()
    }
    
    private func setupUIToolbar() {
        let toolbar = UIToolbar()
        view.addSubview(toolbar)
        let items = [
            newDirectoryBarButtonItem,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            newNoteBarButtonItem]
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.setItems(items, animated: true)
        toolbar.constraintHeight(equalToConstant: FileBrowserViewController.toolbarHeight)
        toolbar.anchors(topAnchor: nil,
                        leadingAnchor: view.leadingAnchor,
                        trailingAnchor: view.trailingAnchor,
                        bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
}
