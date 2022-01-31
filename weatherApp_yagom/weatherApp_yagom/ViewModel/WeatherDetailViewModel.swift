//
//  WeatherDetailViewModel.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

final class WeatherDetailViewModel {
  
  private let weatherRepository: CurrentWeatherRepository
  
  public init(weatherRepository: CurrentWeatherRepository) {
    self.weatherRepository = weatherRepository
  }
  
}
