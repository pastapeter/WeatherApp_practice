//
//  NetworkService.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

final class MainWeatherRemoteAPI: WeatherRemoteAPI  {
  
  public func fetchCityCurrentWeather(in city: String, completion: @escaping(CurrentWeather) -> ()) {
    let url = makeURL(with: city, isCurrent: true)
    NetworkRequest.request(url: url) { result in
      switch result {
      case .success(let data):
        NetworkCoder().getResponse(data: data, style: CurrentWeather.self, completion: completion)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  public func fetchFutureWeather(in city: String, completion: @escaping(FutureWeather)-> ()) {
    let url = makeURL(with: city, isCurrent: false)
    NetworkRequest.request(url: url) { result in
      switch result {
      case .success(let data):
        NetworkCoder().getResponse(data: data, style: FutureWeather.self, completion: completion)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  public func fetchIcon(with name: String, completion: @escaping(String) -> ()) {
    
  }
  
  public init () {
  }
  
  //MARK: - private
  
  private let key = APIInfo.apiKey
  private let baseUrl = APIInfo.baseUrl
  private let iconUrl = APIInfo.iconUrl
  
  private func makeURL(with cityname: String, isCurrent: Bool) -> String {
    var currentParam = "weather"
    if isCurrent == false {
      currentParam = "forecast"
    }
    return baseUrl + "data/2.5/\(currentParam)?q=\(cityname)&appid=\(key)"
  }
  
}




