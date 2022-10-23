//
//  ServiceFactory.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-23.
//

import Foundation

struct ServiceFactory {
    private static func getDataProvider() -> DataProvider {
#if DEBUG
    return MockNetworkAgent()
#else
    return NetworkAgent()
#endif
    }
    
    static func useCaseFor<T>(_ type: T.Type) -> T where T: Service {
        let dataProvider: DataProvider = Self.getDataProvider()
        return type.init(with: dataProvider)
    }
}
