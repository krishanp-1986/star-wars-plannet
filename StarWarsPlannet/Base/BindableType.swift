//
//  BindableType.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-21.
//

import Foundation
import UIKit

protocol BindableType: AnyObject {
    associatedtype ViewModelType
    var viewModel: ViewModelType? { get set }
    func bind()
}

extension BindableType where Self: UIViewController {
    func bindViewModel(_ viewModel: ViewModelType) {
        self.viewModel = viewModel
        bind()
    }
}
