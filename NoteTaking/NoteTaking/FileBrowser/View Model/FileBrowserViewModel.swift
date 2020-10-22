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
    var pathComponentSelected: PublishRelay<Int> { get }
    var createPathComponent: PublishRelay<(String, PathComponent.CType)> { get }
    var deletePathComponent: PublishRelay<Int> { get }
    
    // Output
    var pathTitle: BehaviorRelay<String> { get }
    var pathComponentDriver: Driver<[PathComponent]> { get }
    var errorOnCreatePathComponent: PublishRelay<CreateError> { get }
}

final class FileBrowserViewModelImpl: FileBrowserViewModel {
    
    // MARK: - Input
    let viewDidLoad = PublishRelay<Void>()
    let viewWillAppear = PublishRelay<Void>()
    let pathComponentSelected = PublishRelay<Int>()
    let createPathComponent = PublishRelay<(String, PathComponent.CType)>()
    let deletePathComponent = PublishRelay<Int>()
    
    // MARK: - Output
    let pathTitle = BehaviorRelay<String>(value: "")
    let pathComponentDriver: Driver<[PathComponent]>
    let errorOnCreatePathComponent = PublishRelay<CreateError>()
    
    // MARK: - Private Properties (Rx)
    private let coordinator: FileBrowserCoordinator
    private let disposeBag = DisposeBag()
    private let globalScheduler = ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global())
    
    // MARK: - Private Properties
    private let fileBrowserModel: FileBrowserModel!
    private let pathComponents = BehaviorRelay<[PathComponent]>(value: [])
    
    // MARK: - Initialization
    init(coordinator: FileBrowserCoordinator, url: URL) {
        self.coordinator = coordinator
        fileBrowserModel = FileBrowserModel(url: url)
        
        pathComponentDriver = pathComponents.asDriver(onErrorJustReturn: [])
        
        bindOnViewLifeCycle()
        bindOnPathComponent()
        bindOnToolbar()
    }
    
    // MARK: - Bindings
    private func bindOnViewLifeCycle() {
        viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.pathTitle.accept(self?.fileBrowserModel.name ?? "")
            }).disposed(by: disposeBag)
        
        viewWillAppear
            .subscribeOn(globalScheduler)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.pathComponents.accept(self.fileBrowserModel.getPathComponents())
            }).disposed(by: disposeBag)
    }
    
    private func bindOnPathComponent() {
        pathComponentSelected
            .subscribe(onNext: { [weak self] in
                if let pathComponent = self?.pathComponents.value[$0] {
                    self?.coordinator.push(to: self?.fileBrowserModel.getURL(of: pathComponent), isNote: pathComponent.type == .note)
                }
            }).disposed(by: disposeBag)
        
        deletePathComponent
            .subscribe(onNext: { [weak self] in
                if let self = self {
                    let pathComponent = self.pathComponents.value[$0]
                    if self.fileBrowserModel.deleteDirectory(pathComponent) {
                        var pathComponents = self.pathComponents.value
                        pathComponents.remove(at: $0)
                        self.pathComponents.accept(pathComponents)
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindOnToolbar() {
        createPathComponent
            .subscribe(onNext: { [weak self] in
                do {
                    let newURL = try self?.fileBrowserModel.createDirectory($0, of: $1)
                    if let self = self {
                        self.pathComponents.accept(self.fileBrowserModel.getPathComponents())
                        self.coordinator.push(to: newURL, isNote: $1 == .note)
                    }
                } catch let error as CreateError {
                    self?.errorOnCreatePathComponent.accept(error)
                } catch {
                    assertionFailure("Unknown error on createPathComponent")
                }
            }).disposed(by: disposeBag)
    }
}
