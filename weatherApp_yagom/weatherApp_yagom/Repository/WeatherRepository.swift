//
//  WeatherCurrentRepository.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

final class WeatherRepository: CurrentWeatherRepository, FutureWeatherRepository {
  
  private let remoteAPI: WeatherRemoteAPI
  
  public init(remoteAPI: WeatherRemoteAPI) {
    self.remoteAPI = remoteAPI
  }
  
  func currentWeather(in city: String, completion: @escaping (CurrentWeather) -> ()) {
    remoteAPI.fetchCityCurrentWeather(in: city, completion: completion)
  }
  
  func weatherIcon(iconName: String, completion: @escaping(String) -> ()) {
    remoteAPI.fetchIcon(with: iconName, completion: completion)
  }
  
  func futureWeather(in city: String, completion: @escaping (FutureWeather) -> ()) {
    remoteAPI.fetchFutureWeather(in: city, completion: completion)
  }
  
}

