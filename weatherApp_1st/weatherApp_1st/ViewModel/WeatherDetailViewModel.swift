//
//  WeatherDetailViewModel.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

final class WeatherDetailViewModel {
  
  public init(weatherRepository: CurrentWeatherRepository, cityName: String) {
    self.weatherRepository = weatherRepository
    self.cityName = cityName
    getWeather()
    syncWeather()
  }
  
  var updateUI: (() -> ())?
  
  var weatherInfo: DetailWeatherInfo  = DetailWeatherInfo() {
    didSet {
      updateUI?()
    }
  }
  
  func stopSync() {
    if let timer = timer, timer.isValid {
      timer.invalidate()
    }
  }
  
  func restartSync() {
    if let timer = timer, timer.isValid == false {
      getWeather()
      syncWeather()
    }
  }
  
  let cityName: String
  
  //MARK: - private
  private let weatherRepository: CurrentWeatherRepository
  var timer: Timer?
  
  private func getWeather() {
    self.weatherRepository.currentWeather(in: cityName) { [weak self] weather in
      guard let self = self else {return}
      guard let main = weather.main, let wind = weather.wind else {return}
      self.weatherInfo = DetailWeatherInfo(temp: main.temp, imageUrl: APIInfo.iconUrl+weather.weather[0].icon+".png", feelsLike: main.feelsLikeTemp,
                                           tempMin: main.tempMin, tempMax: main.tempMax,
                                           pressure: main.pressure, humidity: main.humidity,
                                           windSpeed: wind.speed ?? -100,
                                           description: weather.weather[0].description)
    }
  }
  
  private func syncWeather() {
    print("*********** WeatherDetailVM_START ***********")
    timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
      guard let self = self else {return}
      self.getWeather()
    }
  }
  
}

struct DetailWeatherInfo: Equatable {
  var temp: Double = 0.0
  var imageUrl: String = ""
  var feelsLike: Double = 0.0
  var tempMin: Double = 0
  var tempMax: Double = 0.0
  var pressure: Int = 0
  var humidity: Double = 0.0
  var windSpeed: Double = 0.0
  var description: String = ""
}
