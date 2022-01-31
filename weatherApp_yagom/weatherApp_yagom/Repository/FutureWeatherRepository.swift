//
//  FutureWeatherRepository.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

public protocol FutureWeatherRepository: AnyObject {
  func futureWeather(in city: String, completion: @escaping (FutureWeather) -> ())
}
