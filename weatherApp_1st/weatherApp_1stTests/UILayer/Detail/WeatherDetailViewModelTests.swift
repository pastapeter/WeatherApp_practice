//
//  WeatherDetailViewModelTests.swift
//  weatherApp_1stTests
//
//  Created by abc on 2022/03/08.
//

import XCTest
@testable import weatherApp_1st

class WeatherDetailViewModelTests: XCTestCase {
  
  var sut: WeatherDetailViewModel!
  var respository: CurrentWeatherRepository!
  var cityName: String!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    respository = FakeCurrentWeatherRepository()
    cityName = "Seoul"
    sut = WeatherDetailViewModel(weatherRepository: respository, cityName: cityName)
  }
  
  override func tearDownWithError() throws {
    sut = nil
    respository = nil
    cityName = nil
    try super.tearDownWithError()
  }
  
  func givenTimerStop() {
    sut.stopSync()
  }
  
  func test_init_도시이름이_같은가() {
    XCTAssertEqual(sut.cityName, cityName)
  }
  
  func test_init_getWeather이불리는가() {
    
    let weather = CurrentWeather(weather: [Weather(id: 1, main: "hi", description: "hi", icon: "hi")], main: MainWeatherInfo(temp: 1.1, feelsLikeTemp: 1.2, tempMin: 1.3, tempMax: 1.4, pressure: 1, humidity: 1.5, seaLevel: nil, groundLevel: nil), wind: Wind(speed: 1.2, degree: 20, gust: 1.9), id: 5, name: "hihihi")
    let weatherInfo = DetailWeatherInfo(temp: weather.main!.temp, imageUrl: APIInfo.iconUrl+weather.weather[0].icon+".png", feelsLike: weather.main!.feelsLikeTemp, tempMin: weather.main!.tempMin, tempMax: weather.main!.tempMax, pressure: weather.main!.pressure, humidity: weather.main!.humidity, windSpeed: weather.wind?.speed ?? -100, description: weather.weather[0].description)
    
    
    XCTAssertEqual(weatherInfo, sut.weatherInfo)

  }
  
  func test_init_syncWeather() {
    XCTAssertTrue(sut.timer!.isValid)
  }
  
  func test_stopSync를했을때_타이머가멈추는가() {
    //when
    sut.stopSync()
    
    //then
    XCTAssertFalse(sut.timer!.isValid)
  }
  
  func test_restartSync할때_타이머가다시시작되는가() {
    //givne
    givenTimerStop()
    
    //when
    sut.restartSync()
    
    //then
    XCTAssertTrue(sut.timer!.isValid)
  }
  
  func test_restartSync할때_getWeather이시작되는가() {
    //given
    givenTimerStop()
    let weather = CurrentWeather(weather: [Weather(id: 1, main: "hi", description: "hi", icon: "hi")], main: MainWeatherInfo(temp: 1.1, feelsLikeTemp: 1.2, tempMin: 1.3, tempMax: 1.4, pressure: 1, humidity: 1.5, seaLevel: nil, groundLevel: nil), wind: Wind(speed: 1.2, degree: 20, gust: 1.9), id: 5, name: "hihihi")
    let weatherInfo = DetailWeatherInfo(temp: weather.main!.temp, imageUrl: APIInfo.iconUrl+weather.weather[0].icon+".png", feelsLike: weather.main!.feelsLikeTemp, tempMin: weather.main!.tempMin, tempMax: weather.main!.tempMax, pressure: weather.main!.pressure, humidity: weather.main!.humidity, windSpeed: weather.wind?.speed ?? -100, description: weather.weather[0].description)
    let exp = expectation(description: "ddd/??")
    
      //when
    sut.restartSync()
    sut.updateUI = {
      if weatherInfo != self.sut.weatherInfo {
        exp.fulfill()
      }
    }
    
    //then
    wait(for: [exp], timeout: 4)
  }
    
  }
  
  

  
  

