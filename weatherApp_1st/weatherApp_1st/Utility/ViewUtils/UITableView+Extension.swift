//
//  UITableView+Extension.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/30.
//

import Foundation
import UIKit

extension UITableView {
  func register<T: UITableViewCell>(_ cellClass: T.Type){
    let identifier = T.identifier
    self.register(T.self, forCellReuseIdentifier: identifier)
  }
  
  func register<T: UITableViewCell>(_: T.Type) where T: NibLoadableView {
    let nib = UINib(nibName: T.Nibname, bundle: nil)
    register(nib, forCellReuseIdentifier: T.identifier)
  }
}
