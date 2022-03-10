//
//  NetworkRequestTests.swift
//  weatherApp_1stTests
//
//  Created by abc on 2022/03/11.
//

import XCTest
@testable import weatherApp_1st

class NetworkRequestTests: XCTestCase {
  
  var MockSession: MockURLSession!
  var sut: NetworkRequest!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    MockSession = MockURLSession()
    sut = NetworkRequest(session: MockSession)
  }
  
  override func tearDownWithError() throws {
    MockSession = nil
    sut = nil
    try super.tearDownWithError()
  }
  
  func whenGetRequest(data: Data? = nil, statusCode: Int = 200, error: Error? = nil ) -> (calledCompletion: Bool, result: Result<Data, Error>) {
    let urlStr = APIInfo.baseUrl
    let url = URL(string: APIInfo.baseUrl)!
    let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
    
    var calledCompletion = false
    var receivedResult: Result<Data, Error>? = nil
    
    let mockTask = sut.request(url: urlStr) { result in
      calledCompletion = true
      receivedResult = result
    } as! MockURLSessionTask
    
    mockTask.completionHandler(data, response, error)
    return (calledCompletion, receivedResult!)
  }
  
  func test_init_session세팅() {
    XCTAssertTrue(sut.session === MockSession)
  }
  
  func test_request_올바른URL을부르는지() {
    // when
    let mockTask = sut.request(url: APIInfo.baseUrl) { result in } as! MockURLSessionTask
    
    //then
    XCTAssertEqual(mockTask.url, URL(string: APIInfo.baseUrl)!)
  }
  
  func test_request_Task가Resume되는지() {
    // when
    let mockTask = sut.request(url: APIInfo.baseUrl) { result in } as! MockURLSessionTask

    // then
    XCTAssertTrue(mockTask.calledResume)
    
  }
  
  //test는 3가지가 있을 수 있음 (1. 코드가 500일때, 2. 코드가 200인데 애러일때, 3.잘 나올때)
  
  func test_request_500코드_컴플리션이불렸을때() {
    //when
    let result = whenGetRequest(statusCode: 500)
    
    //then
    XCTAssertTrue(result.calledCompletion)
    switch result.result {
    case .failure(let error):
      XCTAssertEqual(error as! NetworkError, NetworkError.failResponse)
    case .success(let data):
      XCTAssertNil(data)
    }
  }
  
  func test_request_Errorin200_컴플리션불렸을때() {
    //given
    let expectedError = NSError(domain: "net.weather", code: 42)
    
    //when
    let result = whenGetRequest(data: nil, statusCode: 200, error: expectedError)
    
    //then
    XCTAssertTrue(result.calledCompletion)
    switch result.result {
    case .failure(let error as NSError):
      XCTAssertEqual(error, expectedError)
    case .success(let data):
      XCTAssertNil(data)
    }
    
  }
  
  func test_request_200Good_컴플리션이불렸을때() throws {
    let data = try Data.fromJSON(fileName: "GET_CurrentWeather")
    
    //when
    let result = whenGetRequest(data: data)
    
    //then
    XCTAssertTrue(result.calledCompletion)
    switch result.result {
    case .success(let data):
      XCTAssertNotNil(data)
    case .failure(let error):
      XCTAssertNil(error)
    }
    
  }
  
  func test_request_200GoodDataisNil_컴플리션이불렸을때() {
    //when
    let result = whenGetRequest(data: nil, statusCode: 200, error: nil)
    
    //then
    XCTAssertTrue(result.calledCompletion)
    switch result.result {
    case .success(let data):
      XCTAssertNotNil(data)
    case .failure(let error):
      XCTAssertEqual(error as! NetworkError, NetworkError.invaildData )
    }
  }
  
}
