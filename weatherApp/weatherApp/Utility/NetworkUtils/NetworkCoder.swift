//
//  NetworkCoder.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation
import RxSwift
import RxCocoa

public class NetworkCoder: NetworkCoding {
  
  func getResponse<T>(data: Data, style: T.Type) -> T? where T : Decodable, T : Encodable {
    let decoder = JSONDecoder()
    guard let body = try? decoder.decode(T.self, from: data) else {
      print("decodingError")
      return nil
    }
    return body
  }
  
  
  public init() {}
  
  func getResponse<T: Codable>(data: Data, style: T.Type, completion: @escaping (T) -> Void) {
    let decoder = JSONDecoder()
    guard let body = try? decoder.decode(T.self, from: data) else {
      print("decodingError")
      return
    }
    completion(body)
  }
  
  func getResponse<T>(data: Data, style: T.Type) -> Observable<T> where T : Decodable, T : Encodable {
    
    return Observable<T>.create { observer in
      
      let decoder = JSONDecoder()
      guard let body = try? decoder.decode(T.self, from: data) else {
        print("Error 발생")
        return observer.onError(NetworkError.invaildData) as! Disposable
      }
      
      observer.onNext(body)
      observer.onCompleted()
      
      return Disposables.create()
    }

  }
  
}


