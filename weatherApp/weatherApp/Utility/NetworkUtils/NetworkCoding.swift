//
//  UserSessionCoding.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation
import RxSwift
import RxCocoa

protocol NetworkCoding: AnyObject {
  func getResponse<T: Codable>(data: Data, style: T.Type, completion: @escaping(T) -> Void)
  func getResponse<T: Codable>(data: Data, style: T.Type) -> Observable<T>
  func getResponse<T: Codable>(data: Data, style: T.Type) -> T?
}
