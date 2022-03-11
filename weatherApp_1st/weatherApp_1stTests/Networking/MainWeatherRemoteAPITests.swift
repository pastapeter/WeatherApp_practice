//
//  MainWeatherRemoteAPI.swift
//  weatherApp_1stTests
//
//  Created by abc on 2022/03/11.
//

import XCTest
@testable import weatherApp_1st

class MainWeatherRemoteAPITests: XCTestCase {
  
  var sut: MainWeatherRemoteAPI!
  var networkRequest: NetworkRequest!
  var coder: NetworkCoder!
  var mockSession: MockURLSession!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    coder = NetworkCoder()
    mockSession = MockURLSession()
    networkRequest = NetworkRequest(session: mockSession)
    sut = MainWeatherRemoteAPI(coder: coder, networkRequest: networkRequest)
  }
  
  override func tearDownWithError() throws {
    coder = nil
    mockSession = nil
    networkRequest = nil
    sut = nil
    try super.tearDownWithError()
  }
  
  func givenCurrentWeatherData() throws -> Data {
    return try Data.fromJSON(fileName: "GET_CurrentWeather")
  }
  
  
  func testRemoteAPI_givenRightURL_callCompletion() throws {
    //given
    // 데이터를 내맘내로 설정 후에 task를 만들어준다.
    let data = try givenCurrentWeatherData()
    
    var calledCompletion = false
    let url = sut.makeURL(with: "Seoul", isCurrent: true)
    let response = HTTPURLResponse(url: URL(string: url)!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    let mockTask = networkRequest.request(url: url) { _ in
    } as! MockURLSessionTask
    
    mockTask.completionHandler(data, response, nil)
    sut.fetchCityCurrentWeather(in: "Seoul") { currentWeather in
      calledCompletion = true      
    }
    
    XCTAssertTrue(calledCompletion)
  }
  
  
  
  
  
  
}
