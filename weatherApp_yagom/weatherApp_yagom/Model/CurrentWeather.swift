//
//  City.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

public struct CurrentWeather: Codable {
  let weather: [Weather]
  let main: MainWeatherInfo
  let wind: Wind
  let id: Int
  let name: String
}
