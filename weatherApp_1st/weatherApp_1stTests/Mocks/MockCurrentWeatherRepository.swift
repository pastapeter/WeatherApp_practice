//
//  MockCurrentWeatherRepository.swift
//  weatherApp_1st
//
//  Created by abc on 2022/03/06.
//

import Foundation

class MockCurrentWeatherRepository: CurrentWeatherRepository {
  
  let weather = CurrentWeather(weather: [Weather(id: 1, main: "hi", description: "hi", icon: "hi")], main: MainWeatherInfo(temp: 1.1, feelsLikeTemp: 1.2, tempMin: 1.3, tempMax: 1.4, pressure: 1, humidity: 1.5, seaLevel: nil, groundLevel: nil), wind: Wind(speed: 1.2, degree: 20, gust: 1.9), id: 5, name: "hihihi")
  let weather2 = CurrentWeather(weather: [Weather(id: 1, main: "hi", description: "hi", icon: "hi")], main: MainWeatherInfo(temp: Double.random(in: 0.0...7.7), feelsLikeTemp: 1.2, tempMin: 1.3, tempMax: 1.4, pressure: 1, humidity: 7.5, seaLevel: nil, groundLevel: nil), wind: Wind(speed: 1.2, degree: 20, gust: 1.9), id: 5, name: "hihihi")
  var callCount = 0
  
  func currentWeather(in city: String, completion: @escaping (CurrentWeather) -> Void) {
    callCount += 1
    var outweather: CurrentWeather? = nil
    if callCount > 1 {
      outweather = weather2
    } else {
      outweather = weather
    }
    print(outweather)
    completion(outweather!)
  }
}
