//
//  WeatherMainViewModel.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

final class WeatherMainViewModel {
  
  private let respository: CurrentWeatherRepository
  private var dataList: [CurrentWeather] = []
  
  init(currentWeatherRepository: CurrentWeatherRepository) {
    self.respository = currentWeatherRepository
    let cityList = CityName.allCases.map {
      $0.rawValue
    }
    cityList.forEach {
      respository.currentWeather(in: $0) { [weak self] weatherInfo in
        self?.dataList.append(weatherInfo)
      }
    }
  }
  

}
