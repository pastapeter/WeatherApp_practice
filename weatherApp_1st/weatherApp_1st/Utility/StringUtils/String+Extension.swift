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
  
  func toDate(format: String) -> Date? {
    var currentStr = self
    if !format.contains("yyyy") {
      let year = Date().toString(dateFormat: "yyyy")
      currentStr = year + "/" + self
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
    dateFormatter.timeZone = TimeZone.autoupdatingCurrent
    dateFormatter.locale = Locale.current
    return dateFormatter.date(from: currentStr)
  }
}
