//
//  Observable.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-22.
//

import Foundation
import RxSwift

extension ObservableType {
    func unwrapped<T>() -> Observable<T> where Element == T? {
        self.compactMap { $0 }
    }
}
