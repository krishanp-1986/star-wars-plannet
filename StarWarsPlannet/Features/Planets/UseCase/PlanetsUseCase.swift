//
//  PlanetsUseCase.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-21.
//

import Foundation
import RxSwift

protocol PlanetsService {
    func fetchPlanets(urlToFetch: String?) -> Single<PlanetsResponse>
}

struct StarWarsPlanetsService: PlanetsService {
    let dataProvider: DataProvider = NetworkAgent()
    func fetchPlanets(urlToFetch: String?) -> Single<PlanetsResponse> {
        guard let request = EndPoint.loadPlanet(urlToFetch).request else {
            let error = NSError(
                domain: Constants.NSErrorConstants.nsErrorDomain,
                code: Constants.NSErrorConstants.failedRequestErrorCode,
                userInfo: nil
            )
            
            return Single.create { single in
                single(.failure(error))
                
                return Disposables.create {}
            }
        }
        
        return dataProvider.execute(request)
    }
}
