//
//  WeatherMainCellModelTests.swift
//  weatherApp_1stTests
//
//  Created by abc on 2022/03/08.
//

import XCTest
@testable import weatherApp_1st

class WeatherMainCellModelTests: XCTestCase {
  
  var sut: WeatherMainCellModel!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = WeatherMainCellModel(name: "test", currentTemperature: 1.2, currentHumid: 1.3, imageUrl: "test")
  }
  
  override func tearDownWithError() throws {
    sut = nil
    try super.tearDownWithError()
  }
  
  func testCellModel_모든것이같을때_같다고하는가() {
    //given
    let another = WeatherMainCellModel(name: "test", currentTemperature: 1.2, currentHumid: 1.3, imageUrl: "test")
    
    //then
    XCTAssertEqual(sut, another)
    
  }
  
  
  
}
