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
    
    // Output
    var noteTitle: BehaviorRelay<String> { get }
}

final class NoteViewModelImpl: NoteViewModel {
    
    // MARK: - Input
    let viewDidLoad = PublishRelay<Void>()
    
    // MARK: - Output
    let noteTitle = BehaviorRelay<String>(value: "")
    
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
    
}
