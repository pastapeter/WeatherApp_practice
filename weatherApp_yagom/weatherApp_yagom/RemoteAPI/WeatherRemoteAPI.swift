//
//  WeatherRemoteAPI.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation
import RxSwift
import RxCocoa

protocol WeatherRemoteAPI: AnyObject {
  func fetchCityCurrentWeather(in city: String, completion: @escaping(CurrentWeather) -> ())
  
  @discardableResult
  func fetchCityCurrentWeather(in city: String) -> Observable<CurrentWeather?>
  
  func fetchFutureWeather(in city: String, completion: @escaping(FutureWeather) -> ())
  
  @discardableResult
  func fetchFutureWeather(in city: String) -> Observable<FutureWeather?>
}
