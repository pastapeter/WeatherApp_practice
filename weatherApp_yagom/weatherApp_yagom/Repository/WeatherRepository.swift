//
//  WeatherCurrentRepository.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation
import RxSwift
import RxCocoa

final class WeatherRepository: CurrentWeatherRepository, FutureWeatherRepository {
  
  //MARK: - private

  private let remoteAPI: WeatherRemoteAPI
  private let futureWeather = PublishRelay<FutureWeather>()
  private let disposeBag = DisposeBag()
  
  public init(remoteAPI: WeatherRemoteAPI) {
    self.remoteAPI = remoteAPI
  }
  
  @discardableResult
  func currentWeather(in city: String) -> Observable<CurrentWeather> {
   return remoteAPI.fetchCityCurrentWeather(in: city)
      .compactMap { $0 }
      .share()
      .asObservable()
  }
  
  @discardableResult
  func futureWeather(in city: String) -> Observable<FutureWeather> {
    remoteAPI.fetchFutureWeather(in: city)
      .compactMap{ $0 }
      .bind(to: futureWeather)
      .disposed(by: disposeBag)
    
    return futureWeather.asObservable()
  }

  
//  func currentWeather(in city: String, completion: @escaping (CurrentWeather) -> ()) {
//    remoteAPI.fetchCityCurrentWeather(in: city, completion: completion)
//  }
//
//  func futureWeather(in city: String, completion: @escaping (FutureWeather) -> ()) {
//    remoteAPI.fetchFutureWeather(in: city, completion: completion)
//  }
  
}

