//
//  NetworkService.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

final class CurrentWeatherRemoteAPI: WeatherRemoteAPI  {
  
  private init () {}
  
  private let key = ApiInfo.apiKey
  private let baseUrl = ApiInfo.baseUrl
  private let iconUrl = ApiInfo.iconUrl
  
  public func fetchCityCurrentWeather(in city: String, completion: @escaping(CurrentWeather) -> ()) {
    
  }
  
  public func fetchFutureWeather(in city: String, completion: @escaping(FutureWeather)-> ()) {
    
  }
  
  public func fetchIcon(with name: String, completion: @escaping(String) -> ()) {
    
  }
  
}



