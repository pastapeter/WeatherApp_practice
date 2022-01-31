//
//  City.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/30.
//

import Foundation

struct CurrentWeatherCellModel {
  var name: String
  var currentTemperature: Double
  var currentHumid: Double
}

extension CurrentWeatherCellModel: Equatable {
  public static func ==(lhs: Self, rhs: Self) -> Bool {
    return lhs.name == rhs.name && lhs.currentTemperature == rhs.currentTemperature && lhs.currentHumid == rhs.currentHumid
  }
}
