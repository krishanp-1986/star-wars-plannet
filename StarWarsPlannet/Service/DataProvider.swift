//
//  DataProvider.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-21.
//

import Foundation
import RxSwift

protocol DataProvider {
    func execute<T: Decodable>(_ request: URLRequest) -> Single<T>
}

enum ServiceError: Error {
    case invalidResponse
    case unSuccessfulResponse(Int)
    case inValidData
    case generalError(Error)
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid Response"
        case .inValidData:
            return "Server failed to return Data"
        case .unSuccessfulResponse(let errorCode):
            return "Server replied with errorCode : \(errorCode)"
        case .generalError(let error):
            return error.localizedDescription
        }
    }
}

extension ServiceError: Equatable {
    static func == (lhs: ServiceError, rhs: ServiceError) -> Bool {
        (lhs as NSError).code == (rhs as NSError).code
    }
}
