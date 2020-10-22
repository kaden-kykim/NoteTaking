//
//  NoteToolbar.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import RxSwift

class NoteToolbar: UIView {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private weak var viewModel: NoteViewModel?
    
    // MARK: - Properties (UI)
    private static let defaultHeight: CGFloat = 40
    private static let defaultPadding: CGFloat = 12
    
    var viewHasKeyboard = false { didSet { setBackgroundHeight() } }
    var safeAreaBottomInset: CGFloat = 0 { didSet { setBackgroundHeight() } }
    private(set) var currentHeight: CGFloat = NoteToolbar.defaultHeight * 2 {
        didSet {
            setToolbarLayout(isPortrait: currentHeight != NoteToolbar.defaultHeight)
            setBackgroundHeight()
        }
    }
    
    let backgroundView = UIView()
    private var toolbarBGHeightConstraint: NSLayoutConstraint!
    private var toolbarheightConstraint: NSLayoutConstraint!
    private var toolbarSystemWidthConstraint: NSLayoutConstraint!
    private var toolbarSystemLeadingConstraint: NSLayoutConstraint!
    
    private lazy var styleButtons: [ToolbarToggleButton] = {
        var buttons = [ToolbarToggleButton]()
        for style in NoteFontStyle.allCases {
            buttons.append(ToolbarToggleButton(image: UIImage.init(systemName: style.description)))
        }
        return buttons
    }()
    private let capturePhoto = ToolbarButton(image: UIImage.init(systemName: "camera.on.rectangle"))
    private let photoLibrary = ToolbarButton(image: UIImage.init(systemName: "photo.on.rectangle"))
    private let undoButton = ToolbarToggleButton(image: UIImage.init(systemName: "arrow.uturn.left"))
    private let redoButton = ToolbarToggleButton(image: UIImage.init(systemName: "arrow.uturn.right"))
    
    // MARK: - Initialization
    required init(viewModel: NoteViewModel) {
        super.init(frame: .zero)
        self.viewModel = viewModel
        
        setupView()
        bindOnToolbar()
    }
    
    
    // MARK: - Sub Classes
    class ToolbarToggleButton: ToolbarButton {
        
        var isOn: Bool {
            didSet { self.tintColor = isOn ? .systemBlue : .placeholderText }
        }
        
        required init(image: UIImage?) {
            isOn = false
            super.init(image: image)
        }
        
        required init?(coder: NSCoder) { fatalError() }
        
    }
    
    class ToolbarButton: UIButton {
        
        required init(image: UIImage?) {
            super.init(frame: .init(origin: .zero, size: .init(width: NoteToolbar.defaultHeight, height: NoteToolbar.defaultHeight)))
            self.setImage(image, for: .normal)
            self.tintColor = .systemBlue
        }
        
        required init?(coder: NSCoder) { fatalError() }
        
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
}

// MARK: - Bindings
extension NoteToolbar {
    private func bindOnToolbar() {
        guard let viewModel = viewModel else { return }
        photoLibrary.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel?.toolbarShowImagePicker.accept(.photoLibrary)
            }).disposed(by: disposeBag)
        
        capturePhoto.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel?.toolbarShowImagePicker.accept(.camera)
            }).disposed(by: disposeBag)
        
        undoButton.rx.tap.subscribe(onNext: { [weak self] in self?.viewModel?.noteUndo.accept(()) }).disposed(by: disposeBag)
        redoButton.rx.tap.subscribe(onNext: { [weak self] in self?.viewModel?.noteRedo.accept(()) }).disposed(by: disposeBag)
        
        for (index, styleButton) in styleButtons.enumerated() {
            styleButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    guard let style = NoteFontStyle.init(rawValue: index) else { return }
                    self?.viewModel?.toolbarStyleTapped.accept(style)
                }).disposed(by: disposeBag)
        }
        
        viewModel.fontStyleStatus
            .subscribe(onNext: { [weak self] in
                if let styleButtons = self?.styleButtons {
                    for (index, styleButton) in styleButtons.enumerated() {
                        styleButton.isOn = $0[index]
                    }
                }
            }).disposed(by: disposeBag)
        
        viewModel.screenRotated
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .landscapeLeft, .landscapeRight:
                    self?.currentHeight = NoteToolbar.defaultHeight
                case .portrait:
                    self?.currentHeight = NoteToolbar.defaultHeight * 2
                default: break
                }
            }).disposed(by: disposeBag)
        
        viewModel.canUndo.subscribe(onNext: { [weak self] in self?.undoButton.isOn = $0 }).disposed(by: disposeBag)
        viewModel.canRedo.subscribe(onNext: { [weak self] in self?.redoButton.isOn = $0 }).disposed(by: disposeBag)
    }
}

// MARK: - UI Setup
extension NoteToolbar {
    
    private func setupView() {
        backgroundColor = .secondarySystemBackground
        toolbarheightConstraint = constraintHeight(equalToConstant: currentHeight).height
        backgroundView.backgroundColor = .secondarySystemBackground
        toolbarBGHeightConstraint = backgroundView.constraintHeight(equalToConstant: currentHeight).height
        
        let photoItems = [capturePhoto, photoLibrary]
        let workItems = [undoButton, redoButton]
        
        let styleStackView = StackView(arrangedSubviews: styleButtons, axis: .horizontal, distribution: .fillEqually)
        styleStackView.constraintWidth(equalToConstant: CGFloat(NoteFontStyle.allCases.count) * NoteToolbar.defaultHeight)
        styleStackView.constraintHeight(equalToConstant: NoteToolbar.defaultHeight)
        
        let workStackView = StackView(arrangedSubviews: workItems, axis: .horizontal, distribution: .fillEqually)
        workStackView.constraintWidth(equalToConstant: CGFloat(workItems.count) * NoteToolbar.defaultHeight)
        let photoStackView = StackView(arrangedSubviews: photoItems, axis: .horizontal, distribution: .fillEqually)
        photoStackView.constraintWidth(equalToConstant: CGFloat(photoItems.count) * NoteToolbar.defaultHeight)
        
        let systemView = UIView()
        toolbarSystemWidthConstraint = systemView
            .constraintWidth(equalToConstant: CGFloat(photoItems.count + workItems.count + 1) * NoteToolbar.defaultHeight).width
        toolbarSystemWidthConstraint.isActive = false
        systemView.constraintHeight(equalToConstant: NoteToolbar.defaultHeight)
        systemView.addSubview(workStackView)
        systemView.addSubview(photoStackView)
        workStackView.anchors(topAnchor: systemView.topAnchor, leadingAnchor: systemView.leadingAnchor, trailingAnchor: nil, bottomAnchor: systemView.bottomAnchor)
        photoStackView.anchors(topAnchor: systemView.topAnchor, leadingAnchor: nil, trailingAnchor: systemView.trailingAnchor, bottomAnchor: systemView.bottomAnchor)
        
        addSubview(styleStackView)
        styleStackView.anchors(topAnchor: topAnchor, leadingAnchor: leadingAnchor, trailingAnchor: nil, bottomAnchor: nil,
                               padding: .init(top: 0, left: NoteToolbar.defaultPadding, bottom: 0, right: 0))
        addSubview(systemView)
        toolbarSystemLeadingConstraint = systemView.anchors(topAnchor: nil, leadingAnchor: leadingAnchor, trailingAnchor: trailingAnchor, bottomAnchor: bottomAnchor,
                                                            padding: .init(top: 0, left: NoteToolbar.defaultPadding, bottom: 0, right: NoteToolbar.defaultPadding)).leading
        toolbarSystemLeadingConstraint.isActive = false
        setToolbarLayout(isPortrait: true)
    }
    
    private func setBackgroundHeight() {
        toolbarBGHeightConstraint.constant = currentHeight + (viewHasKeyboard ? 0 : safeAreaBottomInset)
    }
    
    private func setToolbarLayout(isPortrait: Bool) {
        toolbarheightConstraint.constant = currentHeight
        if isPortrait {
            toolbarSystemWidthConstraint.isActive = false
            toolbarSystemLeadingConstraint.isActive = true
        } else {
            toolbarSystemLeadingConstraint.isActive = false
            toolbarSystemWidthConstraint.isActive = true
        }
    }
    
}
