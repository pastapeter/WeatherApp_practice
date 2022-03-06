//
//  NibLoadableView.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/30.
//

import Foundation
import UIKit

// nib 파일 이름도, 동일하게

protocol NibLoadableView: AnyObject { }

extension NibLoadableView where Self: UIView {
  static var Nibname: String {
    return String(describing: self)
  }
}
