//
//  Planets.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-21.
//

import Foundation
import UIKit

struct Planets {
    static func build() -> UIViewController {
        let navigationController = UINavigationController()
        let planetsVC = PlanetsViewController()
        let useCase = ServiceFactory.useCaseFor(StarWarsPlanetsService.self)
        let planetsViewModel = PlanentsViewModel(with: useCase)
        planetsViewModel.onPlanetDetail = {  planet in
            navigationController.present(PlanetDetail.build(name: planet.name, orbitalPeriod: planet.orbitalPeriod, gravity: planet.gravity), animated:true)
        }
        planetsVC.bindViewModel(planetsViewModel)
        navigationController.viewControllers = [planetsVC]
        return navigationController
    }
}
