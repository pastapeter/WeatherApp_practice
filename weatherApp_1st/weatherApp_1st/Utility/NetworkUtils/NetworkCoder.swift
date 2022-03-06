//
//  NetworkCoder.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

public class NetworkCoder: NetworkCoding {
  
  public init() {}
  
  func getResponse<T: Codable>(data: Data, style: T.Type, completion: @escaping (T) -> Void) {
    let decoder = JSONDecoder()
    guard let body = try? decoder.decode(T.self, from: data) else {
      print("decodingError")
      return
    }
    completion(body)
  }
  
}
