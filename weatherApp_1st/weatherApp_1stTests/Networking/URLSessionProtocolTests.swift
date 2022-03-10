//
//  URLSessionProtocolTests.swift
//  weatherApp_1stTests
//
//  Created by abc on 2022/03/11.
//

import XCTest
@testable import weatherApp_1st

class URLSessionProtocolTests: XCTestCase {
  
  var session: URLSession!
  var url: URL!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    session = URLSession(configuration: .default)
    url = URL(string: "https://example.com")!
  }
  
  override func tearDownWithError() throws {
    session = nil
    url = nil
    try super.tearDownWithError()
  }
  
  
  func test_URLSession_makeDataTask가전달받은URL로task를만드는가() {
    //when
    let task = session.makeDataTask(with: url, completionHandler: {_, _, _ in }) as! URLSessionTask
    
    //then
    XCTAssertEqual(task.originalRequest?.url, url)
  }
  
  
}
