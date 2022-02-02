//
//  Date+Extension.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/02/02.
//

import Foundation

extension Date {
  func toString( dateFormat format: String ) -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = format
          dateFormatter.timeZone = TimeZone.autoupdatingCurrent
          dateFormatter.locale = Locale.current
          return dateFormatter.string(from: self)
    }
}
