//
//  Main.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

public struct MainWeatherInfo: Codable {
  let temp: Double
  let feelsLikeTemp: Double
  let tempMin: Double
  let tempMax: Double
  let pressure: Int
  let humidity: Int
  let seaLevel: Int?
  let groundLevel: Int?
}

extension MainWeatherInfo {
  enum CodingKeys: String, CodingKey {
    case temp, pressure, humidity
    case feelsLikeTemp = "feels_like"
    case tempMin = "temp_min"
    case tempMax = "temp_max"
    case seaLevel = "sea_level"
    case groundLevel = "grnd_level"
    
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    temp = (try? container.decode(Double.self, forKey: .temp)) ?? 2000.0
    feelsLikeTemp = (try? container.decode(Double.self, forKey: .feelsLikeTemp)) ?? 2000.0
    tempMin = (try? container.decode(Double.self, forKey: .tempMin)) ?? 2000.0
    tempMax = (try? container.decode(Double.self, forKey: .tempMax)) ?? 2000.0
    pressure = (try? container.decode(Int.self, forKey: .pressure)) ?? 2000
    humidity = (try? container.decode(Int.self, forKey: .humidity)) ?? 2000
    seaLevel = try? container.decode(Int.self, forKey: .seaLevel)
    groundLevel = try? container.decode(Int.self, forKey: .groundLevel)
  }
  
}
