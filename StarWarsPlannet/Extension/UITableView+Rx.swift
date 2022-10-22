//
//  UITableView+Rx.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-22.
//

import Foundation
import UIKit
import RxSwift

extension UITableView {
    var lastIndexPath: IndexPath {
        guard numberOfSections > 0 else { return IndexPath(row: 0, section: 0)}
        let section = numberOfSections - 1
        let row = max(numberOfRows(inSection: section) - 1, 0)
        return IndexPath(row: row, section: section)
    }
    
    var isLastCellVisible: Bool {
        indexPathsForVisibleRows?.contains(lastIndexPath) == true
    }
}

extension Reactive where Base: UITableView {
    var willDisplayLastCell: Observable<Void> {
        return willDisplayCell
            .filter { $0.indexPath == self.base.lastIndexPath }
            .map { _ in Void() }
            .asObservable()
    }
}
