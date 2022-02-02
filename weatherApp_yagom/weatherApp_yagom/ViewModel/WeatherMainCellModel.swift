//
//  City.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/30.
//

import Foundation

struct WeatherMainCellModel {
  var name: String
  var currentTemperature: Double
  var currentHumid: Double
  var imageUrl: String
}

extension WeatherMainCellModel: Equatable {
  public static func ==(lhs: Self, rhs: Self) -> Bool {
    return lhs.name == rhs.name && lhs.currentTemperature == rhs.currentTemperature && lhs.currentHumid == rhs.currentHumid && lhs.imageUrl == rhs.imageUrl
  }
}
