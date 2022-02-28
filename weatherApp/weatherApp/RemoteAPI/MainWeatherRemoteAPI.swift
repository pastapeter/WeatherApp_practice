//
//  NetworkService.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation
import RxSwift
import RxCocoa

final class MainWeatherRemoteAPI: WeatherRemoteAPI  {
  
  @discardableResult
  func fetchCityCurrentWeather(in city: String) -> Observable<CurrentWeather?> {
    makeURL(with: city, inCurrent: true)
      .flatMap { urlRequest -> Observable<Data> in
        URLSession.rx.shouldLogRequest = { request in
            return false
        }
        return URLSession.shared.rx.data(request: urlRequest)
      }
      .map { data -> CurrentWeather? in
        return self.networkCoder.getResponse(data: data, style: CurrentWeather.self)
      }
      .catchAndReturn(nil)
  }
  
  @discardableResult
  func fetchFutureWeather(in city: String) -> Observable<FutureWeather?> {
    makeURL(with: city, inCurrent: false)
      .flatMap { urlRequest -> Observable<Data> in
        URLSession.rx.shouldLogRequest = { request in
            return false
        }
        return URLSession.shared.rx.data(request: urlRequest)
      }
      .map { data -> FutureWeather? in
        return self.networkCoder.getResponse(data: data, style: FutureWeather.self)
      }
      .catchAndReturn(nil)
  }
  
  
//  public func fetchCityCurrentWeather(in city: String, completion: @escaping(CurrentWeather) -> ()) {
//    let url = makeURL(with: city, isCurrent: true)
//    NetworkRequest.request(url: url) { [weak self] result in
//      guard let self = self else {return}
//      switch result {
//      case .success(let data):
//        self.networkCoder.getResponse(data: data, style: CurrentWeather.self, completion: completion)
//      case .failure(let error):
//        print(error)
//      }
//    }
//  }
//
//  public func fetchFutureWeather(in city: String, completion: @escaping(FutureWeather)-> ()) {
//    let url = makeURL(with: city, isCurrent: false)
//    NetworkRequest.request(url: url) { [weak self] result in
//      guard let self = self else {return}
//      switch result {
//      case .success(let data):
//        self.networkCoder.getResponse(data: data, style: FutureWeather.self, completion: completion)
//      case .failure(let error):
//        print(error)
//      }
//    }
//  }
  
  public init (coder: NetworkCoding) {
    self.networkCoder = coder
  }
  
  //MARK: - private
  
  private let key = APIInfo.apiKey
  private let baseUrl = APIInfo.baseUrl
  private let networkCoder: NetworkCoding
  
//  private func makeURL(with cityname: String, isCurrent: Bool) -> String {
//    var currentParam = "weather"
//    if isCurrent == false {
//      currentParam = "forecast"
//    }
//    return baseUrl + "data/2.5/\(currentParam)?q=\(cityname)&appid=\(key)"
//  }
  
  // URLRequest를 Observable로 내보내기
  private func makeURL(with cityname: String, inCurrent: Bool) -> Observable<URLRequest> {
    
    var currentParam = "weather"
    if inCurrent == false {
      currentParam = "forecast"
    }
    let urlStr = baseUrl + "data/2.5/\(currentParam)?q=\(cityname)&appid=\(key)"
    
    return Observable.just(urlStr)
      .compactMap {URL(string: $0)}
      .map {URLRequest(url: $0)}
  }
  
}




