//
//  City.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

public struct CurrentWeather: Codable {
  let weather: [Weather]
  let main: MainWeatherInfo?
  let wind: Wind?
  let id: Int
  let name: String
}

extension CurrentWeather {
  enum CodingKeys: String, CodingKey {
    case weather, main, wind, id, name
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    weather = (try? container.decode([Weather].self, forKey: .weather)) ?? []
    main = try? container.decode(MainWeatherInfo.self, forKey: .main)
    wind = try? container.decode(Wind.self, forKey: .wind)
    id = (try? container.decode(Int.self, forKey: .id)) ?? -1
    name = (try? container.decode(String.self, forKey: .name)) ?? "unknown"
  }
}
