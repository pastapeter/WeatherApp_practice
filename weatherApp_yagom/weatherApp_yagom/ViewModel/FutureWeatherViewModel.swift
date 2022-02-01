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
  var updateUI: (() -> Void)?
  
  public init(futureWeatherRepository: FutureWeatherRepository, cityName: String) {
    self.futureWeatherRepository = futureWeatherRepository
    self.cityname = cityName
    getForecast()
  }
  
  var forecast: [(time: String, tempMax: Double, tempMin: Double, humid: Double)] = [] {
    didSet {
      updateUI?()
    }
  }
  
  func getForecast() {
    self.futureWeatherRepository.futureWeather(in: self.cityname) { [weak self] weather in
      guard let self = self else {return}
      var temp :  [(time: String, tempMax: Double, tempMin: Double, humid: Double)] = []
      weather.list.forEach {
        temp.append((time: $0.date.forMattingDate(), tempMax: $0.main.tempMax, tempMin: $0.main.tempMin, humid: $0.main.humidity ))
      }
      self.forecast = temp
    }
  }
  
}
