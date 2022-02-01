//
//  FutureWeatherViewModel.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/02/01.
//

import Foundation

final class FutureWeatherViewModel {
  
  private let futureWeatherRepository: FutureWeatherRepository
  let cityname: String
  
  public init(futureWeatherRepository: FutureWeatherRepository, cityName: String) {
    self.futureWeatherRepository = futureWeatherRepository
    self.cityname = cityName
  }
  
}
