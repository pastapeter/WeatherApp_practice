//
//  WeatherMainTableViewCell.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/30.
//

import UIKit

final class WeatherMainTableViewCell: UITableViewCell, NibLoadableView {
  
  @IBOutlet weak var weatherImageView: UIImageView!
  @IBOutlet weak var cityNameLabel: UILabel!
  @IBOutlet weak var currentTemperatureLabel: UILabel!
  @IBOutlet weak var currentHumidLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
}

extension WeatherMainTableViewCell {
  func bind(cellModel: CurrentWeatherCellModel) {
    currentHumidLabel.text = "\(cellModel.currentHumid)%"
    currentTemperatureLabel.text = "\(cellModel.currentTemperature)"
    cityNameLabel.text = "\(cellModel.name)"
  }
}

