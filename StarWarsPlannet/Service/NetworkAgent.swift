//
//  NetworkAgent.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-21.
//

import Foundation
import RxSwift

final class NetworkAgent: DataProvider {
    private let session: URLSession
    private var dataTask: URLSessionDataTask?
    
    init(with session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func execute<T: Decodable>(_ request: URLRequest) -> Single<T> {
        Single.create { single in
            self.dataTask = self.session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let responseError = error {
                        single(.failure(ServiceError.generalError(responseError)))
                        return
                    }
                    guard response != nil else {
                        single(.failure(ServiceError.invalidResponse))
                        return
                    }
                    let httpUrlResponseCode = (response as? HTTPURLResponse)?.statusCode ?? 500
                    guard 200..<300 ~= httpUrlResponseCode else {
                        single(.failure(ServiceError.unSuccessfulResponse(httpUrlResponseCode)))
                        return
                    }
                    guard let responseData = data, !responseData.isEmpty else {
                        single(.failure(ServiceError.inValidData))
                        return
                    }
                    do {
                        let responseModel = try JSONDecoder().decode(T.self, from: responseData)
                        single(.success(responseModel))
                    } catch let error {
                        single(.failure(ServiceError.generalError(error)))
                    }
                }
            }
            self.dataTask?.resume()
            
            return Disposables.create {
                self.dataTask?.cancel()
            }
        }
    }
}
