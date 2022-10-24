//
//  UIViewController+Rx.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-21.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var viewDidLoaded: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in  Void() }
        return ControlEvent(events: source)
    }
}
