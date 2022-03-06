//
//  WeatherRemoteAPI.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

protocol WeatherRemoteAPI: AnyObject {
  func fetchCityCurrentWeather(in city: String, completion: @escaping(CurrentWeather) -> ())
  func fetchFutureWeather(in city: String, completion: @escaping(FutureWeather) -> ())
}
