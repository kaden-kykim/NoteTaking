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
        bindOnImagePicker()
        
        viewModel.viewDidLoad.accept(())
    }
    
    // MARK: - Properties
    var viewModel: NoteViewModel!
    private let disposeBag = DisposeBag()

    // MARK: - Properties (UI)
    private lazy var note = NoteTextView(viewModel: viewModel)
    private lazy var toolbar = NoteToolbar(viewModel: viewModel)
    
    private var noteBottomConstraint: NSLayoutConstraint!
    private var noteBottomConstraintWithSafe: NSLayoutConstraint!
    private var toolbarBottomConstraint: NSLayoutConstraint!
    private var toolbarBottomConstraintWithSafe: NSLayoutConstraint!
    private var toolbarBGBottomConstraint: NSLayoutConstraint!
    
}

// MARK: - Bindings
extension NoteViewController {
    
    private func bindOnNavigationBar() {
        viewModel.noteTitle
            .subscribe(onNext: { [weak self] title in
                DispatchQueue.main.async { self?.title = title }
            }).disposed(by: disposeBag)
    }
    
    private func bindOnImagePicker() {
        viewModel.toolbarShowImagePicker
            .subscribe(onNext: { [weak self] sourceType in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = sourceType
                self?.present(imagePicker, animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
}


// MARK: - UI Setup
extension NoteViewController {
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = editButtonItem
        
        registerNotifications()
        
        setupUINote()
        setupUIToolbar()
    }
    
    private func setupUINote() {
        view.addSubview(note)
        let anchors = note.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor,
                                   leadingAnchor: view.safeAreaLayoutGuide.leadingAnchor,
                                   trailingAnchor: view.safeAreaLayoutGuide.trailingAnchor,
                                   bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor,
                                   padding: .init(top: 2, left: 8, bottom: toolbar.currentHeight + 2, right: 8))
        noteBottomConstraintWithSafe = anchors.bottom
        noteBottomConstraint = note.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    }
    
    private func setupUIToolbar() {
        view.addSubview(toolbar.backgroundView)
        toolbarBGBottomConstraint = toolbar.backgroundView.anchors(topAnchor: nil,
                                                                   leadingAnchor: view.leadingAnchor,
                                                                   trailingAnchor: view.trailingAnchor,
                                                                   bottomAnchor: view.bottomAnchor).bottom
        view.addSubview(toolbar)
        toolbarBottomConstraintWithSafe = toolbar.anchors(topAnchor: nil,
                                                          leadingAnchor: view.safeAreaLayoutGuide.leadingAnchor,
                                                          trailingAnchor: view.safeAreaLayoutGuide.trailingAnchor,
                                                          bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor).bottom
        toolbarBottomConstraint = toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if !editing { note.resignFirstResponder() }
        else { note.becomeFirstResponder() }
    }
    
}

// MARK: - Notification Control
extension NoteViewController {
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(screenRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func keyboardWasShown(_ notification: Notification) {
        guard let info = notification.userInfo, let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardSizeHeight = keyboardFrame.cgRectValue.size.height
        
        toolbar.viewHasKeyboard = true
        noteBottomConstraint.constant = -keyboardSizeHeight - toolbar.currentHeight
        toolbarBottomConstraint.constant = -keyboardSizeHeight
        toolbarBGBottomConstraint.constant = -keyboardSizeHeight
        noteBottomConstraintWithSafe.isActive = false
        noteBottomConstraint.isActive = true
        toolbarBottomConstraintWithSafe.isActive = false
        toolbarBottomConstraint.isActive = true
        UIView.animate(withDuration: 0.1) { self.view.layoutIfNeeded() }
        setEditing(true, animated: true)
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification) {
        toolbar.viewHasKeyboard = false
        noteBottomConstraint.isActive = false
        noteBottomConstraintWithSafe.isActive = true
        toolbarBottomConstraint.isActive = false
        toolbarBottomConstraintWithSafe.isActive = true
        toolbarBGBottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
    
    @objc func screenRotated(_ notification: Notification) {
        viewModel.screenRotated.accept(UIDevice.current.orientation)
        DispatchQueue.main.async { [weak self] in
            if let self = self {
                self.toolbar.safeAreaBottomInset = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
                self.noteBottomConstraintWithSafe.constant = -(self.toolbar.currentHeight + 2)
                self.view.layoutIfNeeded()
            }
        }
    }
    
}

// MARK: - ImagePicker Methods and Delegate
extension NoteViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedIamge = info[.originalImage] as? UIImage else { return }
        viewModel.attachImageFromPicker.accept(selectedIamge)
        picker.dismiss(animated: true, completion: nil)
    }
    
}
