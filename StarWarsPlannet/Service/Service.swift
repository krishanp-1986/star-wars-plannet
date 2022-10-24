//
//  Service.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-23.
//

import Foundation

protocol Service {
    var dataProvider: DataProvider! { get set }
    init()
}

extension Service {
    init(with dataProvider: DataProvider) {
        self.init()
        self.dataProvider = dataProvider
    }
}
