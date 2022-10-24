//
//  CellConfigurable.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-22.
//

import Foundation
import UIKit

protocol CellConfigurable: UITableViewCell {
    associatedtype ViewModel
    func configure(with viewModel: ViewModel)
}
