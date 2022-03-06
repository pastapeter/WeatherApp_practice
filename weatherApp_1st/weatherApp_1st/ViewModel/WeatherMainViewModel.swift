//
//  WeatherMainViewModel.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

final class WeatherMainViewModel {
  
  var updatedUI: (() -> ())?
  var selectedCity: String = ""
  var datasource: [WeatherMainCellModel] = [] {
    didSet {
      updatedUI?()
    }
  }
  
  
  init(currentWeatherRepository: CurrentWeatherRepository) {
    self.respository = currentWeatherRepository
    cityList = CityName.allCases.map {
      $0.rawValue
    }
    getWeather()
    syncWeather()
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

  
  //MARK: - Private
  
  private let respository: CurrentWeatherRepository
  private var dataList: [CurrentWeather] = [] {
    didSet {
      convertToCellModel()
    }
  }
  private var tempDatasource: [WeatherMainCellModel] = []
  
  var cityList: [String] = []
  var timer: Timer?
  
  private func getWeather() {
    var tempList: [CurrentWeather] = []
    self.cityList.enumerated().forEach { (index, city) in
      self.respository.currentWeather(in: city) { [weak self] weatherInfo in
        guard let self = self else { return }
        var weatherInfo = weatherInfo
        weatherInfo.name = city
        tempList.append(weatherInfo)
        if tempList.count == self.cityList.count {
          self.dataList = tempList
        }
      }
    }
  }
  
  private func syncWeather() {
    timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
      guard let self = self else {return }
      print("*********** START ***********")
      self.getWeather()
    }
  }
  
  private func convertToCellModel(){
    dataList.enumerated().forEach { (index, item) in
      if let main = item.main {
        let cellmodel = WeatherMainCellModel(name: item.name, currentTemperature: main.temp, currentHumid: main.humidity, imageUrl: APIInfo.iconUrl + item.weather[0].icon + ".png")
        if self.tempDatasource.count == cityList.count {
          if self.tempDatasource[index] != cellmodel {
            self.tempDatasource[index] = cellmodel
          }
        } else {
          self.tempDatasource.append(cellmodel)
        }
      }
    }
    self.datasource = self.tempDatasource
  }
  
}
