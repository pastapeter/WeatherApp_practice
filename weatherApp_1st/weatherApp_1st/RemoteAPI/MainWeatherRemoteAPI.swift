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
    _ = networkRequest.request(url: url) { [weak self] result in
      guard let self = self else {return}
      switch result {
      case .success(let data):
        self.networkCoder.getResponse(data: data, style: CurrentWeather.self, completion: completion)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  public func fetchFutureWeather(in city: String, completion: @escaping(FutureWeather)-> ()) {
    let url = makeURL(with: city, isCurrent: false)
    _ = networkRequest.request(url: url) { [weak self] result in
      guard let self = self else {return}
      switch result {
      case .success(let data):
        self.networkCoder.getResponse(data: data, style: FutureWeather.self, completion: completion)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  public init (coder: NetworkCoding, networkRequest: NetworkRequest = NetworkRequest(session: URLSession.shared)) {
    self.networkCoder = coder
    self.networkRequest = networkRequest
  }
  
  //MARK: - private
  
  private let key = APIInfo.apiKey
  private let baseUrl = APIInfo.baseUrl
  private let networkCoder: NetworkCoding
  private let networkRequest: NetworkRequest
  
  private func makeURL(with cityname: String, isCurrent: Bool) -> String {
    var currentParam = "weather"
    if isCurrent == false {
      currentParam = "forecast"
    }
    return baseUrl + "data/2.5/\(currentParam)?q=\(cityname)&appid=\(key)"
  }
  
}




