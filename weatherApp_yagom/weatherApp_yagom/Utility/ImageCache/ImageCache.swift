//
//  ImageCache.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/02/02.
//

import UIKit

protocol ImageCache {
  func getIcon(with url: String , completion: @escaping(UIImage?) -> Void)
}
