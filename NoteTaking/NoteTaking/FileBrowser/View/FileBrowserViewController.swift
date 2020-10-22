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
        bindOnTableView()
        bindOnToolbar()
        
        viewModel.viewDidLoad.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear.accept(())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setEditing(false, animated: true)
    }
    
    // MARK: - Properties
    var viewModel: FileBrowserViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties (UI)
    private static let toolbarHeight: CGFloat = 44
    private lazy var pathComponentsTableView = PathComponentTableView()
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
    
    private func bindOnTableView() {
        viewModel.pathComponentDriver
            .drive(pathComponentsTableView.rx.items(cellIdentifier: PathComponentTableViewCell.reuseIdentifier,
                                                    cellType: PathComponentTableViewCell.self))
            { _, pathComponent, cell in
                cell.setPathComponent(pathComponent)
            }.disposed(by: disposeBag)
        
        pathComponentsTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] in
                self?.pathComponentsTableView.deselectRow(at: $0, animated: true)
                self?.viewModel.pathComponentSelected.accept($0.row)
            }).disposed(by: disposeBag)
        
        pathComponentsTableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                let alert = UIAlertController(title: "Item delete", message: "Are you sure?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    self?.viewModel.deletePathComponent.accept(indexPath.row)
                }))
                self?.present(alert, animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    private func bindOnToolbar() {
        newDirectoryBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                NewComponentAlert.create(of: .directory) {
                    self?.viewModel.createPathComponent.accept(($0, .directory))
                }.present(on: self)
            }).disposed(by: disposeBag)

        
        newNoteBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                NewComponentAlert.create(of: .note) {
                    self?.viewModel.createPathComponent.accept(($0, .note))
                }.present(on: self)
            }).disposed(by: disposeBag)
        
        viewModel.errorOnCreatePathComponent
            .subscribe (onNext: { [weak self] error in
                let alert = UIAlertController(title: "Create Error", message: nil, preferredStyle: .alert)
                switch error {
                case .AlreadyExist:
                    alert.message = "Input name already exists.\nPlease use another name."
                case .DirectoryHasNoteSuffix:
                    alert.message = "Invalid name.\nPlease use another name."
                case .System:
                    alert.message = "System Error.\n(\(error.localizedDescription))"
                }
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - UI Setup
extension FileBrowserViewController {
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = editButtonItem
        
        setupUITableView()
        setupUIToolbar()
    }
    
    private func setupUITableView() {
        view.addSubview(pathComponentsTableView)
        pathComponentsTableView.anchors(
            topAnchor: view.safeAreaLayoutGuide.topAnchor,
            leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor,
            bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor,
            padding: .init(top: 0, left: 0, bottom: FileBrowserViewController.toolbarHeight, right: 0))
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        pathComponentsTableView.setEditing(editing, animated: animated)
    }
    
}
