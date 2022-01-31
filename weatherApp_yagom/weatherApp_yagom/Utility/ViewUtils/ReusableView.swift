//
//  ReusableView.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/30.
//

import Foundation
import UIKit

// tableview에 identifier, 파일이름과 동일하다

protocol ReusableView: AnyObject {
  
}

extension ReusableView where Self: UIView {
  static var identifier: String {
    return String(describing: self)
  }
}

extension UITableViewCell: ReusableView { }
