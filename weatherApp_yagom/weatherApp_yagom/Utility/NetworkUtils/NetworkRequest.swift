//
//  NetworkRequest.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

final class NetworkRequest {
  
  typealias URLSessionResult = ( Result<Data, Error>) -> (Void)
  
  static func request(url: String, completion: @escaping URLSessionResult) {
    URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
        completion(.failure(NetworkError.failResponse))
        return
      }
      
      guard let data = data else {
        completion(.failure(NetworkError.invaildData))
        return
      }
      
      completion(.success(data))
    }.resume()
  }
  
  static func requestWithEpemeral(url: String, completion: @escaping URLSessionResult) {
    print(url)
    URLSession(configuration: .ephemeral).dataTask(with: URL(string: url)!) { (data, response, error) in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
        completion(.failure(NetworkError.failResponse))
        return
      }
      
      guard let data = data else {
        completion(.failure(NetworkError.invaildData))
        return
      }
      
      completion(.success(data))
    }.resume()
  }
  
}
