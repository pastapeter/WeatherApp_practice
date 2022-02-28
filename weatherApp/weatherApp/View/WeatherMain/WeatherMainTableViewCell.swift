//
//  WeatherMainTableViewCell.swift
//  weatherApp
//
//  Created by abc on 2022/01/30.
//

import UIKit
import RxSwift

final class WeatherMainTableViewCell: UITableViewCell, NibLoadableView {
  
  var viewModel: WeatherMainCellModel? {
    didSet {
      guard let viewModel = viewModel else { return }
      currentHumidLabel.text = "\(viewModel.currentHumid)%"
      currentTemperatureLabel.text = String(format: "%.2f℃", viewModel.currentTemperature)
      cityNameLabel.text = "\(viewModel.name)"
    }
  }
  
  @IBOutlet weak var weatherImageView: UIImageView!
  @IBOutlet weak var cityNameLabel: UILabel!
  @IBOutlet weak var currentTemperatureLabel: UILabel!
  @IBOutlet weak var currentHumidLabel: UILabel!
  
  var disposeBag = DisposeBag()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    weatherImageView.image = nil
    disposeBag = DisposeBag()
  }
  
}

extension WeatherMainTableViewCell {
  func bind(cellModel: WeatherMainCellModel) {
    self.viewModel = cellModel
  }
}



