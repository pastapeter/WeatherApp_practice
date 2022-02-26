//
//  WeatherMainViewModel.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation
import RxSwift
import RxCocoa

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
  }
  
  func restartSync() {
    if let timer = timer, timer.isValid == false {
    }
  }
  
  func select(item:WeatherMainCellModel) {
    self.stopSync()
    self.selectedCity = item.name
  }

  
  //MARK: - Private
  
  private let respository: CurrentWeatherRepository
  private var dataList: [CurrentWeather] = [] {
    didSet {
      convertToCellModel()
    }
  }
  private var tempDatasource: [WeatherMainCellModel] = []
  
  private var cityList: [String] = []
  private var timer: Timer?
  private var disposeBag = DisposeBag()
  
  private func stopSync() {
    if let timer = timer, timer.isValid {
      timer.invalidate()
    }
  }
  
  // 연산자를 활용해서 SyncWeather과 합칠 예정
  func getWeatherWithRx() -> Driver<[WeatherMainCellModel]> {
  
    let tempRelay = PublishRelay<CurrentWeather>()
    var list = [WeatherMainCellModel]()
    
    cityList.forEach { city in
      self.respository.currentWeather(in: city)
        .bind(to: tempRelay)
        .disposed(by: disposeBag)
    }
    
    return tempRelay
      .withUnretained(self)
      .map({ (viewmodel, currentweather) -> [WeatherMainCellModel] in
        list.append(viewmodel.convertToCellModelRx(item: currentweather)!)
        return list
      })
      .skip(while: { [weak self] in
        guard let self = self else {return false}
        return $0.count != self.cityList.count} )
      .asDriver(onErrorJustReturn: [])
  }
  
  private func convertToCellModelRx(item: CurrentWeather) -> WeatherMainCellModel? {
      if let main = item.main {
        let cellmodel = WeatherMainCellModel(name: item.name, currentTemperature: main.temp, currentHumid: main.humidity, imageUrl: APIInfo.iconUrl + item.weather[0].icon + ".png")
        return cellmodel
        }
    return nil
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

