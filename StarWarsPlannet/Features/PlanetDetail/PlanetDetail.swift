//
//  PlanetDetail.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-22.
//

import Foundation
import UIKit

struct PlanetDetail {
    static func build(name: String, orbitalPeriod: String, gravity: String) -> UIViewController {
        PlanetDetailViewController(with: name, orbitalPeriod: orbitalPeriod, gravity: gravity)
    }
}
