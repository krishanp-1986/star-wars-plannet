//
//  PlanetsDataProvider.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-21.
//

import Foundation
import RxSwift
import RxCocoa

protocol PlanetsDataProvider {
    var nextUrl: String? { get }
    var onPlanetDetail: ((Planet) -> Void)? { get set }
    init(with useCase: PlanetsService)
    func bind(input: PlanentsViewModel.Input) -> Observable<PlanentsViewModel.State?>
}

final class PlanentsViewModel: PlanetsDataProvider {
    var nextUrl: String?
    var onPlanetDetail: ((Planet) -> Void)?
    
    struct Input {
        var didLoad: Observable<Void>
        var willDisplayLastCell: Observable<Void>
    }
    init(with useCase: PlanetsService = StarWarsPlanetsService()) {
        self.useCase = useCase
    }
    
    func bind(input: Input) -> Observable<State?> {
        disposeBag.insert(
            input.didLoad.subscribe { _ in
                self.fetchPlanets()
            },
            input.willDisplayLastCell.subscribe(onNext: { _ in
                guard !self.isFullyLoaded, let next = self.nextUrl else { return }
                self.fetchPlanets(next)
            })
        )
        
        return self.state.asObservable()
    }
    
    // MARK: - Private
    
    private func fetchPlanets(_ urlToFetch: String? = nil) {
        self.state.accept(.loading)
        self
            .useCase
            .fetchPlanets(urlToFetch: urlToFetch)
            .subscribe {[weak self] response in
                self?.isFullyLoaded = (response.next == nil)
                self?.nextUrl = response.next
                let cellViewModels = response.results.map {
                    PlanetCellViewModel(planet: $0)
                }
                self?.state.accept( urlToFetch != nil ? .nextLoaded(cellViewModels) : .loaded(cellViewModels))
            } onFailure: { error in
                self.state.accept(.failed(error))
            }
            .disposed(by: disposeBag)
    }
    
    private let disposeBag: DisposeBag = .init()
    private let useCase: PlanetsService
    private let state: PublishRelay<State?> = .init()
    private var isFullyLoaded = false
}

extension PlanentsViewModel {
    enum State {
        case loading
        case loaded([PlanetCellViewModel])
        case nextLoaded([PlanetCellViewModel])
        case failed(Error)
    }
}
