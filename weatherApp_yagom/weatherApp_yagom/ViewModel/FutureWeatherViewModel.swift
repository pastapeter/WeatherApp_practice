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
  var timer: Timer?
  
  public init(futureWeatherRepository: FutureWeatherRepository, cityName: String) {
    self.futureWeatherRepository = futureWeatherRepository
    self.cityname = cityName
    getForecast()
    syncWeather()
  }
  
  var forecast: [(time: String, tempMax: Double, tempMin: Double, humid: Double)] = [] {
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
      syncWeather()
    }
  }
  
  //MARK: - Private
  
  private func getForecast() {
    self.futureWeatherRepository.futureWeather(in: self.cityname) { [weak self] weather in
      guard let self = self else {return}
      var temp :  [(time: String, tempMax: Double, tempMin: Double, humid: Double)] = []
      weather.list.forEach {
        temp.append((time: $0.date.forMattingDate(), tempMax: $0.main.tempMax, tempMin: $0.main.tempMin, humid: $0.main.humidity ))
      }
      self.forecast = temp
    }
  }
  
  // 현재시간과 지금 가지고 있는 최종시간과 비교, 1분에 1번씩 비교
  private func syncWeather() {
   timer = Timer.init(timeInterval: 60, repeats: true) { [weak self] _ in
      guard let self = self else {return}
      if !self.forecast.isEmpty  {
        if let recent = self.forecast[0].time.toDate(format: "MM/dd HH:mm"), recent >= Date() {
          self.getForecast()
        }
      }
    }
  }
  
  
  
}
