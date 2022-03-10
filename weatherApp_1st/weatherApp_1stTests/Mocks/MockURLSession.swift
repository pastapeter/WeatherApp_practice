//
//  MockURLSession.swift
//  weatherApp_1stTests
//
//  Created by abc on 2022/03/10.
//

import Foundation

class MockURLSession: URLSessionProtocol {
  
  var queue: DispatchQueue? = nil
  
  func givenDispatchQueue() {
    queue = DispatchQueue(label: "weatherTests.MockSession")
  }
  
  func makeDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol {
    return MockURLSessionTask(completionHandler: completionHandler, url: url, queue: queue)
  }
  
}

class MockURLSessionTask: URLSessionTaskProtocol {
  var completionHandler: (Data?, URLResponse?, Error?) -> Void
  var url: URL
  
  init(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void,
       url: URL,
       queue: DispatchQueue?) {
    if let queue = queue {
      self.completionHandler = { data, response, error in
        queue.async {
          completionHandler(data, response, error)
        }
      }
    } else {
      self.completionHandler = completionHandler
    }
    self.url = url
  }
  
  var calledResume = false
  func resume() {
    calledResume = true
  }
  
  
}
