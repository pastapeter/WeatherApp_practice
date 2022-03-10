//
//  URLSessionProtocol.swift
//  weatherApp_1stTests
//
//  Created by abc on 2022/03/10.
//

import Foundation

protocol URLSessionProtocol: AnyObject {
  func makeDataTask(with url: URL, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol
}

protocol URLSessionTaskProtocol: AnyObject {
  func resume()
}

extension URLSessionTask: URLSessionTaskProtocol { }

extension URLSession: URLSessionProtocol {
  func makeDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol {
    return dataTask(with: url, completionHandler: completionHandler)
  }
}
