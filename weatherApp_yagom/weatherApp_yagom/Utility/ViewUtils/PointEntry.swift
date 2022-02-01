//
//  PointEntry.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/02/02.
//

import Foundation

// LineChart 그릴때 필요한 point엔트리

struct PointEntry {
  let value: Double
  let label: String
}

extension PointEntry: Comparable {
  static func < (lhs: PointEntry, rhs: PointEntry) -> Bool {
    return lhs.value < rhs.value
  }

  static func == (lhs: PointEntry, rhs: PointEntry) -> Bool {
    return lhs.value == rhs.value
  }

}
