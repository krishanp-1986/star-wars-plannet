//
//  Colors.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-24.
//

import Foundation
import UIKit

extension DesignSystem {
  public struct Colors {
    
    // MARK: - Texts
      public let textPrimary = UIColor(light: .systemBlue, dark: .systemBlue)
    public let textSecondary = UIColor.systemGray
    
    // Background
      public let backgroundPrimary = UIColor(light: .white, dark: .white)
  }
}

public extension UIColor {
  /// Return `UIColor` used in light mode.
  var light: UIColor {
    resolvedColor(with: .init(userInterfaceStyle: .light))
  }
  
  /// Return `UIColor` used in dark mode.
  var dark: UIColor {
    resolvedColor(with: .init(userInterfaceStyle: .dark))
  }
  
  /// Initialize a `UIColor` from a light and dark colors pair.
  /// - Parameters:
  ///   - light: color to be used in light mode.
  ///   - dark: color to be used in dark mode.
  convenience init(light: UIColor, dark: UIColor) {
    self.init { traits in
      switch traits.userInterfaceStyle {
      case .dark:
        return dark
      default:
        return light
      }
    }
  }
}
