//
//  Data+JSON.swift
//  weatherApp_1stTests
//
//  Created by abc on 2022/03/11.
//

import Foundation
import XCTest

extension Data {
  
  public static func fromJSON(fileName: String,
                              file: StaticString = #file,
                              line: UInt = #line) throws -> Data {
    
    let bundle = Bundle(for: TestBundleClass.self)
    let url = try XCTUnwrap(bundle.url(forResource: fileName, withExtension: "JSON"),
                            "\(fileName).json 파일을 찾을 수 없습니다.",
      file: file, line: line)
    return try Data(contentsOf: url)
  }
}

private class TestBundleClass { }
