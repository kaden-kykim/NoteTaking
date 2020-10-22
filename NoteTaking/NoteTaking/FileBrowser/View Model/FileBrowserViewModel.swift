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
    var pushTo: PublishRelay<(URL, Bool)> { get }
    
    // Output
    var pathTitle: BehaviorRelay<String> { get }
    
}

final class FileBrowserViewModelImpl: FileBrowserViewModel {
    
    // MARK: - Input
    let viewDidLoad = PublishRelay<Void>()
    let pushTo = PublishRelay<(URL, Bool)>()
    
    // MARK: - Output
    let pathTitle = BehaviorRelay<String>(value: "")
    
    // MARK: - Private Properties (Rx)
    private let coordinator: FileBrowserCoordinator
    private let disposeBag = DisposeBag()
    
    // MARK: - Private Properties
    private let pathURL: URL
    
    // MARK: - Initialization
    init(coordinator: FileBrowserCoordinator, pathURL: URL) {
        self.coordinator = coordinator
        self.pathURL = pathURL
        
        bindOnViewLifeCycle()
        bindOnNavigation()
    }
    
    // MARK: - Bindings
    private func bindOnViewLifeCycle() {
        viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.pathTitle.accept(self?.pathURL.lastPathComponent ?? "")
            }).disposed(by: disposeBag)
    }
    
    private func bindOnNavigation() {
        pushTo
            .subscribe(onNext: { [weak self] url, isNote in
                self?.coordinator.push(to: url, isNote: isNote)
            }).disposed(by: disposeBag)
        
    }
}
