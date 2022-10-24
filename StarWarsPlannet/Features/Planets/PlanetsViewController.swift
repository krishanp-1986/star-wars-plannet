//
//  PlanetsViewController.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-21.
//

import UIKit
import RxSwift
import RxCocoa

class PlanetsViewController: BaseViewController<PlanetsDataProvider> {
    override func loadView() {
        super.loadView()
        buildUI()
        self.title = "Planets"
    }
    override func bind() {
        let input = PlanentsViewModel.Input(
            didLoad: self.rx.viewDidLoaded.asObservable(),
            willDisplayLastCell: Observable.merge(self.planetsTableView.rx.willDisplayLastCell, tableViewUpdated.asObservable())
        )
        let outPut = self.viewModel?.bind(input: input)
        outPut?
            .unwrapped()
            .subscribe(onNext: { [weak self] state in
                self?.handleStateChange(with: state)
            })
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Private
    private func handleStateChange(with newState: PlanentsViewModel.State) {
        self.shouldShowLoading(false)
        switch newState {
        case .loading:
            self.shouldShowLoading(true)
        case .failed(let error):
            self.displayBasicAlert(message: error.localizedDescription)
        case .loaded(let cellViewModels):
            self.tableViewAdapter.insertPlanets(cellViewModels)
            reloadTableView()
        case .nextLoaded(let cellViewModels):
            self.tableViewAdapter.updatePlanets(cellViewModels)
            reloadTableView()
        }
    }
    
    private func reloadTableView() {
        self.planetsTableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            if self?.planetsTableView.isLastCellVisible == true {
                self?.tableViewUpdated.accept(())
            }
        }
    }
    
    private func buildUI() {
        self.view.addSubview(planetsTableView)
        let safeAreaLayoutGuide = self.view.safeAreaLayoutGuide
        self.planetsTableView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private lazy var planetsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerCell(PlanetTableViewCell.self)
        return tableView
    }()
    
    private lazy var tableViewAdapter: PlanetsTableViewAdapter = {
        let adapter = PlanetsTableViewAdapter(with: planetsTableView)
        adapter.onItemClick = { planet in
            self.viewModel?.onPlanetDetail?(planet)
        }
        return adapter
    }()
    
    private let tableViewUpdated: PublishRelay<Void> = .init()
}
