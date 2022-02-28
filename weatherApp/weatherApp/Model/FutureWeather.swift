//
//  FutureWeather.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

public struct FutureWeather: Codable {
  let cnt: Int
  let list: [Forecast]
}


