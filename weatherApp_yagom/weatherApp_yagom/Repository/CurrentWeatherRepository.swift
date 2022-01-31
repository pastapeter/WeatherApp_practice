//
//  WeatherRepository.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

public protocol CurrentWeatherRepository: AnyObject {
  func currentWeather(in city: String, completion: @escaping(CurrentWeather)->())
  func weatherIcon(iconName: String, completion: @escaping(String)->())
}

