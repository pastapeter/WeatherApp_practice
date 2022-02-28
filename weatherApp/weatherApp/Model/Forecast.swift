//
//  Forecast.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

public struct Forecast: Codable {
  let main: MainWeatherInfo
  let weather: [Weather]
  let wind: Wind
  let date: String
}

extension Forecast {
  enum CodingKeys: String, CodingKey {
    case main, weather, wind
    case date = "dt_txt"
  }
}
