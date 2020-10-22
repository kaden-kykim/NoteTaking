//
//  NoteViewModel.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import RxSwift
import RxCocoa

protocol NoteViewModel: AnyObject {
    // Input
    var viewDidLoad: PublishRelay<Void> { get }
    var screenRotated: BehaviorRelay<UIDeviceOrientation> { get }
    
    // Input: Note
    var noteDidChange: PublishRelay<NSAttributedString> { get }
    
    // Input: Toolbar
    var toolbarStyleTapped: PublishRelay<NoteFontStyle> { get }
    var toolbarShowImagePicker: PublishRelay<UIImagePickerController.SourceType> { get }
    
    // Output
    var setEditing: PublishRelay<Bool> { get }
    var noteTitle: BehaviorRelay<String> { get }
    var noteFileIOError: PublishRelay<NoteFileIOError> { get }
    
    // Output: Note
    var noteUndo: PublishRelay<Void> { get }
    var noteRedo: PublishRelay<Void> { get }
    var toggleStyle: PublishRelay<(NoteFontStyle, Bool)> { get }
    var attachImageFromPicker: PublishRelay<UIImage> { get }
    
    // Output: Toolbar
    var canUndo: BehaviorRelay<Bool> { get }
    var canRedo: BehaviorRelay<Bool> { get }
    var fontStyleStatus: BehaviorRelay<[Bool]> { get }
}

final class NoteViewModelImpl: NoteViewModel {
    
    // MARK: - Input
    let viewDidLoad = PublishRelay<Void>()
    let screenRotated = BehaviorRelay<UIDeviceOrientation>(value: .portrait)
    
    // MARK: - Input: Note
    let noteDidChange = PublishRelay<NSAttributedString>()
    
    // MARK: - Input: Toolbar
    let toolbarStyleTapped = PublishRelay<NoteFontStyle>()
    let toolbarShowImagePicker = PublishRelay<UIImagePickerController.SourceType>()
    
    // MARK: - Output
    let setEditing = PublishRelay<Bool>()
    let noteTitle = BehaviorRelay<String>(value: "")
    let noteFileIOError = PublishRelay<NoteFileIOError>()
    
    // MARK: - Output: Note
    let noteUndo = PublishRelay<Void>()
    let noteRedo = PublishRelay<Void>()
    let toggleStyle = PublishRelay<(NoteFontStyle, Bool)>()
    let attachImageFromPicker = PublishRelay<UIImage>()

    // MARK: - Output: Toolbar
    let canUndo = BehaviorRelay<Bool>(value: false)
    let canRedo = BehaviorRelay<Bool>(value: false)
    let fontStyleStatus = BehaviorRelay<[Bool]>(value: [Bool](repeating: false, count: NoteFontStyle.allCases.count))
    
    // MARK: - Private Properties (Reactive)
    private let coordinator: Coordinator
    private let disposeBag = DisposeBag()
    private let backgroundScheduler = ConcurrentDispatchQueueScheduler.init(qos: .background)
    
    // MARK: - Private Properties
    private let noteModel: NoteModel!
        
    // MARK: - Initialization
    init(coordinator: Coordinator, fileURL: URL) {
        self.coordinator = coordinator
        self.noteModel = NoteModel(url: fileURL)
        
        bindOnViewLifecycle()
        bindOnToolbar()
    }
    
    // MARK: - Bindings
    private func bindOnViewLifecycle() {
        viewDidLoad
            .observeOn(backgroundScheduler)
            .subscribeOn(backgroundScheduler)
            .subscribe(onNext: { [weak self] in
                self?.noteTitle.accept(self?.noteModel.name ?? "")
            }).disposed(by: disposeBag)
    }
    
    private func bindOnToolbar() {
        toolbarStyleTapped
            .subscribe(onNext: { [weak self] style in
                guard let self = self else { return }
                self.toggleStyle.accept((style, self.fontStyleStatus.value[style.rawValue]))
            }).disposed(by: disposeBag)
    }
    
}
