
//
//  WeatherMainViewModel.swift
//  weatherApp
//
//  Created by abc on 2022/01/31.
//

import Foundation
import RxSwift
import RxCocoa

final class WeatherMainViewModel {

  var selectedCity: String = ""

  init(currentWeatherRepository: CurrentWeatherRepository) {
    self.respository = currentWeatherRepository
    cityList = CityName.allCases.map {
      $0.rawValue
    }
  }
  
  func select(item:WeatherMainCellModel) {
    self.running.accept(false)
    self.selectedCity = item.name
  }
  
  
  //MARK: - Private
  
  private let respository: CurrentWeatherRepository

  private var cityList: [String] = []
  private var disposeBag = DisposeBag()
  
  private func stopSync() {
    self.disposeBag = DisposeBag()
  }
  
  func viewWillAppear() {
    running.accept(true)
  }
  
  private var running: BehaviorRelay = BehaviorRelay(value: true)
  
  // 연산자를 활용해서 SyncWeather과 합칠 예정
  var weatherInfo: Driver<[WeatherMainCellModel]> {
    
    let tempRelay = PublishRelay<[WeatherMainCellModel]>()
    var list = [WeatherMainCellModel]()

    let isRunning = running.asObservable()
      .debug("타이머 굴러가는중")
      .flatMapLatest { isRunning in
        isRunning ? Observable<Int>
        .timer(.seconds(0), period: .seconds(5), scheduler: MainScheduler.instance) : .empty() }
    
    isRunning
      .withUnretained(self)
      .filter { _ in list.isEmpty }
      .subscribe(onNext: { viewModel, int in
        viewModel.cityList.forEach { city in
          viewModel.respository.currentWeather(in: city)
            .map {
              viewModel.convertToCellModelRx(item: $0)!
            }
            .subscribe(onNext: {
              list.append($0)
              if list.count == viewModel.cityList.count {
                tempRelay.accept(list)
                list.removeAll()
              }
            })
            .disposed(by: viewModel.disposeBag)
        }
      })
      .disposed(by: disposeBag)
      
    return tempRelay
      .asDriver(onErrorJustReturn: [])
  }
  
  private func convertToCellModelRx(item: CurrentWeather) -> WeatherMainCellModel? {
    if let main = item.main {
      let cellmodel = WeatherMainCellModel(name: item.name, currentTemperature: main.temp, currentHumid: main.humidity, imageUrl: APIInfo.iconUrl + item.weather[0].icon + ".png")
      return cellmodel
    }
    return nil
  }

}

