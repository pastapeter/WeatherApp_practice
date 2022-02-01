//
//  LineChart.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/02/01.
//

import UIKit

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

class LineChart: UIView {
  
  private var columnStardardLabel = UILabel()
  
  //각 포인트 마다 갭?
  private let lineGap: CGFloat = 80.0
  
  // 차트 상단에 남는 공간
  private let topSpace: CGFloat = 40.0
  
  // 차트 하단에 남는 공간
  private let bottomSpace: CGFloat = 40.0
  
  // 가장 높은 줄은 차트의 가장 높은 값보다 10% 커야한다.
  private let topHorizontalLine: CGFloat = 1.1
  
  var dataEntries: [PointEntry]? {
    didSet {
      self.setNeedsLayout()
    }
  }
  
  var humidDataEntries: [PointEntry]? {
    didSet {
      self.setNeedsLayout()
    }
  }
  
  var minTempDataEntries: [PointEntry]? {
    didSet {
      self.setNeedsLayout()
    }
  }
  
  // 메인 라인
  private let dataLayer: CALayer = CALayer()
  
  private let mainLayer: CALayer = CALayer()
  
  // 메인레이어와 각각의 데이터 엔트리의 라벨을 가짐
  private let scrollView: UIScrollView = UIScrollView()
  
  // horizontal Line
  private let gridLayer: CALayer = CALayer()
  
  private var dataPoints: [CGPoint]?
  private var dataPointsList: [[CGPoint]] = []
  private var humidDataPoints: [CGPoint]?
  private var minDataPoints: [CGPoint]?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  convenience init() {
    self.init(frame: CGRect.zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
    setupcolumnStandardLabel()
  }
  
  private func setupView() {
    mainLayer.addSublayer(dataLayer)
    scrollView.layer.addSublayer(mainLayer)
    
    self.layer.addSublayer(gridLayer)
    self.addSubview(scrollView)
    self.backgroundColor = .white
    
  }
  
  private func setupcolumnStandardLabel() {
    columnStardardLabel.text = "기온/습도"
    columnStardardLabel.font = UIFont.systemFont(ofSize: 10)
    columnStardardLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(columnStardardLabel)
    columnStardardLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
    columnStardardLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
  }
  
  override func layoutSubviews() {
    scrollView.frame = CGRect(x: 50, y: 0,
                              width: self.frame.size.width,
                              height: self.frame.size.height)
    if let dataEntries = dataEntries {
      scrollView.contentSize = CGSize(width: CGFloat(dataEntries.count) * lineGap, height: self.frame.size.height)
      mainLayer.frame = CGRect(x: 0, y: 0, width: CGFloat(dataEntries.count) * lineGap, height: self.frame.size.height)
      dataLayer.frame = CGRect(x: 0, y: topSpace, width: mainLayer.frame.width, height: mainLayer.frame.height - topSpace - bottomSpace)
      
      dataPoints = convertDataEntriesToPoints(entries: dataEntries)
      if let humidDataEntries = humidDataEntries {
        humidDataPoints = convertDataEntriesToPoints(entries: humidDataEntries)
      }
      if let mindTempDataEntries = minTempDataEntries {
        minDataPoints = convertDataEntriesToPoints(entries: mindTempDataEntries)
      }
      
      gridLayer.frame = CGRect(x: 0, y: topSpace, width: self.frame.width, height: mainLayer.frame.height - topSpace - bottomSpace)
      clean()
      drawHorizontalLines()
      drawChart()
      drawLabels()
    }
  }
  
  private func convertDataEntriesToPoints(entries: [PointEntry]) -> [CGPoint] {
    if let max = entries.max()?.value, let min = entries.min()?.value {
      var result: [CGPoint] = []
      
      let minMaxRange: CGFloat = CGFloat(max - min) * topHorizontalLine
      for i in 0..<entries.count {
        let height = dataLayer.frame.height * (1 - ((CGFloat(entries[i].value) - CGFloat(min)) / minMaxRange ))
        let point = CGPoint(x: CGFloat(i)*lineGap + 40, y: height)
        result.append(point)
      }
      return result
    }
    return []
  }
  
  //ZIGZAG
  private func drawChart() {
    
    let tempPointList = [dataPoints, minDataPoints, humidDataPoints]
    dataPointsList = tempPointList.compactMap {$0}
    
    for (index, points) in dataPointsList.enumerated() {
      if points.count > 0, let path = createPath(with: points) {
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        if index == 0 {
          lineLayer.strokeColor = UIColor.red.cgColor
        } else if index == 1 {
          lineLayer.strokeColor = UIColor.blue.cgColor
        } else {
          lineLayer.strokeColor = UIColor.black.cgColor
        }
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.lineWidth = 3
        lineLayer.lineJoin = .round
        lineLayer.lineCap = .round
        dataLayer.addSublayer(lineLayer)
      }
    }
  }
  
  private func createPath(with dataPoints: [CGPoint]?) -> UIBezierPath? {
    guard let dataPoints = dataPoints, dataPoints.count > 0 else {
      return nil
    }
    
    let path = UIBezierPath()
    path.move(to: dataPoints[0])
    for i in 1..<dataPoints.count {
      path.addLine(to: dataPoints[i])
    }
    return path
    
  }
  
  //가로축 + Label
  private func drawLabels() {
    if let dataEntries = dataEntries, dataEntries.count > 0 {
      for i in 0..<dataEntries.count {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: lineGap*CGFloat(i) - lineGap/2 + 40, y: mainLayer.frame.height - bottomSpace/2 - 8, width: lineGap, height: 16)
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.backgroundColor = UIColor.white.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
        textLayer.fontSize = 11
        textLayer.string = dataEntries[i].label
        mainLayer.addSublayer(textLayer)
      }
    }
  }
  
  // 그리드 라인 그리기
  private func drawHorizontalLines() {
    guard let dataEntries = dataEntries, let minTempDataEntries = minTempDataEntries, let humidDataEntries = humidDataEntries else {
      return
    }
    
    var gridValues: [CGFloat]? = nil
    if dataEntries.count < 4 && dataEntries.count > 0 {
      gridValues = [0,1]
    } else if dataEntries.count >= 4 {
      gridValues = [0, 0.25, 0.5, 0.75, 1]
    }
    if let gridValues = gridValues {
      for value in gridValues {
        let height = value * gridLayer.frame.size.height

        let path = UIBezierPath()
        path.move(to: CGPoint(x:0, y: height))
        path.addLine(to: CGPoint(x: gridLayer.frame.size.width, y: height))

        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        lineLayer.fillColor = UIColor.black.cgColor
        lineLayer.strokeColor = UIColor.black.cgColor
        lineLayer.lineWidth = 0.5
        if value > 0.0 && value < 1.0 {
          lineLayer.lineDashPattern = [4,4]
        }

        gridLayer.addSublayer(lineLayer)
        
        var lineValue: (Double, Double) = (0,0)
        if let maxInTempMax = dataEntries.max()?.value,
           let minInTempMax = dataEntries.min()?.value, let maxInTempMin = minTempDataEntries.max()?.value, let minInTempMin = minTempDataEntries.min()?.value {
          let min = (minInTempMax + minInTempMin) / 2
          let max = (maxInTempMax + maxInTempMin) / 2
          lineValue.0 = getColumnValue(value: value, min: min, max: max)
        }
        if let max = humidDataEntries.max()?.value, let min = humidDataEntries.min()?.value {
          lineValue.1 = getColumnValue(value: value, min: min, max: max)
        }
        
        // 세로축 TEXT
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: 4, y: height, width: 60, height: 16)
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
        textLayer.fontSize = 12
        let tempStr = String(format: "%.2f", lineValue.0 )
        textLayer.string = "\(tempStr)/\(Int(lineValue.1))"
        gridLayer.addSublayer(textLayer)
      }
    }
    
  }
  
  private func getColumnValue(value: CGFloat, min: Double, max: Double) -> Double {
    var minMaxGap: CGFloat = 0
    minMaxGap = CGFloat(max - min) * topHorizontalLine
    return Double((1 - value) * minMaxGap) + Double(min)
  }
  
  private func clean() {
    mainLayer.sublayers?.forEach({ layer in
      if layer is CATextLayer {
        layer.removeFromSuperlayer()
      }
    })
    dataLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
    gridLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
  }
  
  
}
