//
//  Wind.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

public struct Wind: Codable {
  let speed: Double? //풍속
  let degree: Int? //풍향
  let gust: Double? //돌풍
}

extension Wind {
  enum CodingKeys: String, CodingKey {
      case speed
      case degree = "deg"
      case gust
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    speed = try? container.decode(Double.self, forKey: .speed)
    degree = try? container.decode(Int.self, forKey: .degree)
    gust = try? container.decode(Double.self, forKey: .gust)
  }
  
}




