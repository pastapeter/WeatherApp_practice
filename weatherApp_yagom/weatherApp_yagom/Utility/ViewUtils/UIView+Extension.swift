//
//  UIView+Extension.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/30.
//

import Foundation
import UIKit

extension UIView {
  func setRound(with radius: CGFloat? = nil) {
    if let radius = radius {
      self.layer.cornerRadius = radius
    } else {
      self.layer.cornerRadius = self.bounds.height / 2
    }
    self.layer.masksToBounds = true
  }
}
