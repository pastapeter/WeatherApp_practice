//
//  Coordinate.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

public struct Weather: Codable {
  let id: String
  let main: String
  let description: String
  let icon: String
}
