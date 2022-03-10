//
//  NetworkError.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

enum NetworkError: String, Error {
  case failResponse
  case invaildData
  case unknown
}
