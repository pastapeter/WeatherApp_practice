//
//  WeatherMainViewModel.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

final class WeatherMainViewModel {
  
  var updatedUI: (() -> ())?
  var datasource: [CurrentWeatherCellModel] = [] {
    didSet {
      updatedUI?()
    }
  }
  
  
  init(currentWeatherRepository: CurrentWeatherRepository) {
    self.respository = currentWeatherRepository
    cityList = CityName.allCases.map {
      $0.rawValue
    }
    syncWeather()
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
  
  private let respository: CurrentWeatherRepository
  private var dataList: [CurrentWeather] = [] {
    didSet {
      convertToCellModel()
    }
  }
  private var tempDatasource: [CurrentWeatherCellModel] = []
  
  private var cityList: [String] = []
  private var timer: Timer?
  
  private func syncWeather() {
    timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
      guard let self = self else {return }
      print("*********** START ***********")
      var tempList: [CurrentWeather] = []
      self.cityList.enumerated().forEach { (index, city) in
        self.respository.currentWeather(in: city) { weatherInfo in
          var weatherInfo = weatherInfo
          weatherInfo.name = city
          tempList.append(weatherInfo)
          if tempList.count == self.cityList.count {
            self.dataList = tempList
          }
        }
      }
    }
  }
  
  private func convertToCellModel(){
    dataList.enumerated().forEach { (index, item) in
      if let main = item.main {
        let cellmodel = CurrentWeatherCellModel(name: item.name, currentTemperature: main.temp, currentHumid: main.humidity)
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
