//
//  WeatherDetailViewModel.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation
import RxSwift
import RxCocoa

final class WeatherDetailViewModel {
  
  public init(weatherRepository: CurrentWeatherRepository, cityName: String) {
    self.weatherRepository = weatherRepository
    self.cityName = cityName
  }

  func stopSync() {
    if let timer = timer, timer.isValid {
      timer.invalidate()
    }
  }
  
  func restartSync() {
    
  }
  
  let cityName: String
  
  var weatherInfo: Driver<[String]> {
    
    let tempRelay = PublishRelay<[String]>()
    
    Observable<Int>
      .timer(.milliseconds(0), period: .seconds(3), scheduler: MainScheduler.instance)
      .withUnretained(self)
      .subscribe { (viewmodel, index) in
        viewmodel.weatherRepository.currentWeather(in: viewmodel.cityName)
          .subscribe(onNext: { weather in
            var info = [String]()
            if let main = weather.main, let wind = weather.wind {
              info = [viewmodel.cityName, APIInfo.iconUrl+weather.weather[0].icon+".png", main.temp, main.feelsLikeTemp, main.tempMin, main.tempMax, main.pressure, main.humidity, wind.speed ?? -100, weather.weather[0].description].map { "\($0)"}
              tempRelay.accept(info)
            }
          })
          .disposed(by: viewmodel.disposeBag)
      }
      .disposed(by: disposeBag)
    
    return tempRelay
      .asDriver(onErrorJustReturn: [])
  }
  
  //MARK: - private
  private var weatherRepository: CurrentWeatherRepository
  private var timer: Timer?
  private var disposeBag = DisposeBag()
  
}

