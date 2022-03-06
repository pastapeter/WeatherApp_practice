//
//  WeatherMainViewModelTests.swift
//  weatherApp_1stTests
//
//  Created by abc on 2022/03/06.
//

import XCTest
@testable import weatherApp_1st

class WeatherMainViewModelTests: XCTestCase {
  
  var sut: WeatherMainViewModel!
  var mock: MockCurrentWeatherRepository!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    mock = MockCurrentWeatherRepository()
    sut = WeatherMainViewModel(currentWeatherRepository: mock)
  }
  
  override func tearDownWithError() throws {
    sut = nil
    mock = nil
    try super.tearDownWithError()
  }
  
  //MARK: - Given
  
  func givenTimerStop() {
    sut.stopSync()
  }

  
  func testMainViewModel_시작했을때_도시수가맞는지() {
    //then
    XCTAssertEqual(sut.cityList.count, CityName.allCases.count)
  }
  
  func testMainViewModel_시작했을때_날씨를받아오는지() {
    //then
    XCTAssertEqual(sut.datasource.count, CityName.allCases.count)
  }
  
  func testMainViewModel_시작했을때_날씨를받아오는타이머가켜지는지(){
    let exp = expectation(description: "날씨를 받아오는 타이머 켜짐")
    
    sut.updatedUI = {
      exp.fulfill()
    }
    
    wait(for: [exp], timeout: 4)
  }
  
  func testMainViewModel_CurrentWeather가업데이트될때_dataSource가업데이트되는지() {
    //then
    XCTAssertEqual(sut.datasource.first, WeatherMainCellModel(name: sut.cityList.first!, currentTemperature: 1.1, currentHumid: 1.5, imageUrl: APIInfo.iconUrl+"hi.png"))
  }
  
  func testMainViewModel_stopSync를부를때_Timer가꺼지는지() {
    
    //when
    sut.stopSync()
    
    //then
    XCTAssertFalse(sut.timer!.isValid)
  }
  
  func testMainViewModel_restartSync부를때_API작업을하는지() {
    //given
    givenTimerStop()
    let exp = expectation(description: "API작업시작")
    if mock.callCount > 0 {
      exp.fulfill()
    }
    
    //when
    sut.restartSync()
    
    //then
    wait(for: [exp], timeout: 1)
  }
  
  func testMainViewModel_restartSync부를때_UIUpdate시작하는지() {
    //given
    givenTimerStop()
    let exp = expectation(description: "UI작업시작")
    sut.updatedUI = {
      exp.fulfill()
    }
    
    //when
    sut.restartSync()
    
    //then
    wait(for: [exp], timeout: 1)
  }
}
