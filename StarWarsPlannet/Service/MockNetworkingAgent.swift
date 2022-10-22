//
//  MockNetworkingAgent.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-22.
//

import Foundation
import RxSwift

struct MockNetworkAgent: DataProvider {
    func execute<T: Decodable>(_ request: URLRequest) -> Single<T> {
        Single.create { single in
            guard let path = request.url?.lastPathComponent else {
                single(.failure(ServiceError.unSuccessfulResponse(404)))
                return Disposables.create {}
            }
            
            guard let data = JsonUtils.convertJsonIntoDecodable(T.self, fileName: path) else {
                single(.failure(ServiceError.inValidData))
                return Disposables.create {}
            }
            
            single(.success(data))
            
            return Disposables.create {}
        }
    }
}
