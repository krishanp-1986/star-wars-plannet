//
//  TestNetworkAgent.swift
//  StarWarsPlannetTests
//
//  Created by Krishantha Sunil Premaretna on 2022-10-23.
//

import Foundation
import RxSwift
@testable import StarWarsPlannet

class TestNetworkAgent: DataProvider {
  private let bundle = Bundle(for: TestNetworkAgent.self)
  var mockFileName: String = ""
    
    func execute<T>(_ request: URLRequest) -> Single<T> where T : Decodable {
        Single.create { single in
            DispatchQueue.main.async {
              guard let decodable = JsonUtils.convertJsonIntoDecodable(T.self,
                                                                       fileName: self.mockFileName,
                                                                       bundle: self.bundle, inDirectory: "TestResponse") else {
                
                single(.failure(ServiceError.inValidData))
                return
              }
              
              single(.success(decodable))
            }
            
            return Disposables.create {}
        }
    }
}
