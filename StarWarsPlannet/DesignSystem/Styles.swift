//
//  Styles.swift
//  StarWarsPlannet
//
//  Created by Krishantha Sunil Premaretna on 2022-10-24.
//

import Foundation
import UIKit

public typealias Style<Component> = (Component) -> Void

public extension DesignSystem {
  struct Styles {
    public lazy var headerLabel: Style<UILabel> = { label in
      label.numberOfLines = 0
      label.textColor = DesignSystem.shared.colors.textPrimary
      label.font = DesignSystem.shared.fonts.header
    }
    
    public lazy var description: Style<UILabel> = { label in
      label.numberOfLines = 0
      label.textColor = DesignSystem.shared.colors.textSecondary
      label.font = DesignSystem.shared.fonts.description
    }
  }
}
