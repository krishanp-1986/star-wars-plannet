//
//  MockPlanetsUsecase.swift
//  StarWarsPlannetTests
//
//  Created by Krishantha Sunil Premaretna on 2022-10-23.
//

import Foundation
import RxSwift

@testable import StarWarsPlannet

struct MockPlanetUsecase: PlanetsService {
    func fetchPlanets(urlToFetch: String?) -> Single<PlanetsResponse> {
        (dataProvider as? TestNetworkAgent)?.mockFileName = "emptyplanets"
        return dataProvider.execute(.init(url: URL(string: "https://swapi.dev/api/emptyplanets")!))
    }
    
    var dataProvider: DataProvider! = TestNetworkAgent()
}

