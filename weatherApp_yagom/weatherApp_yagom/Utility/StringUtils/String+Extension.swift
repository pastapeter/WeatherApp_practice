//
//  Date+Extension.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/02/01.
//

import Foundation

extension String {
  func forMattingDate() -> String {
    let timeArr = self.components(separatedBy: " ")
    let date = timeArr[0].components(separatedBy: "-")[1...2].joined(separator: "/")
    let time = timeArr[1].components(separatedBy: ":")[0...1].joined(separator: ":")
    return date + " " + time    
  }
}
