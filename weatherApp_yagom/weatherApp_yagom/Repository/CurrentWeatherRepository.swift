//
//  WeatherRepository.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation
import RxSwift
import RxCocoa

public protocol CurrentWeatherRepository: AnyObject {
//  func currentWeather(in city: String, completion: @escaping(CurrentWeather)->Void)
  
  @discardableResult
  func currentWeather(in city: String) -> Observable<CurrentWeather>
}

