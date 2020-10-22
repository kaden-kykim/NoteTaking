//
//  FileBrowserViewModel.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import RxSwift
import RxCocoa

protocol FileBrowserViewModel: AnyObject {
    // Input
    var viewDidLoad: PublishRelay<Void> { get }
    var viewWillAppear: PublishRelay<Void> { get }
    var pushTo: PublishRelay<(URL, Bool)> { get }
    
    // Output
    var pathTitle: BehaviorRelay<String> { get }
    var pathComponentDriver: Driver<[PathComponent]> { get }
    
}

final class FileBrowserViewModelImpl: FileBrowserViewModel {
    
    // MARK: - Input
    let viewDidLoad = PublishRelay<Void>()
    let viewWillAppear = PublishRelay<Void>()
    let pushTo = PublishRelay<(URL, Bool)>()
    
    // MARK: - Output
    let pathTitle = BehaviorRelay<String>(value: "")
    let pathComponentDriver: Driver<[PathComponent]>
    
    // MARK: - Private Properties (Rx)
    private let coordinator: FileBrowserCoordinator
    private let disposeBag = DisposeBag()
    private let globalScheduler = ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global())
    
    // MARK: - Private Properties
    private let pathURL: URL
    private let fileBrowserModel = FileBrowserModel.instance
    private let pathComponents = BehaviorRelay<[PathComponent]>(value: [])
    
    // MARK: - Initialization
    init(coordinator: FileBrowserCoordinator, pathURL: URL) {
        self.coordinator = coordinator
        self.pathURL = pathURL
        
        pathComponentDriver = pathComponents.asDriver(onErrorJustReturn: [])
        
        bindOnViewLifeCycle()
        bindOnNavigation()
    }
    
    // MARK: - Bindings
    private func bindOnViewLifeCycle() {
        viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.pathTitle.accept(self?.pathURL.lastPathComponent ?? "")
            }).disposed(by: disposeBag)
        
        viewWillAppear
            .subscribeOn(globalScheduler)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.pathComponents.accept(self.fileBrowserModel.getPathComponents(self.pathURL))
            }).disposed(by: disposeBag)
    }
    
    private func bindOnNavigation() {
        pushTo
            .subscribe(onNext: { [weak self] url, isNote in
                self?.coordinator.push(to: url, isNote: isNote)
            }).disposed(by: disposeBag)
        
    }
}
