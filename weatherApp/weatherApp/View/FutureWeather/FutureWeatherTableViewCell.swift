//
//  FutureWeatherTableViewCell.swift
//  weatherApp
//
//  Created by abc on 2022/02/01.
//

import UIKit

class FutureWeatherTableViewCell: UITableViewCell, NibLoadableView {

  @IBOutlet weak var lineChart: LineChart!
  @IBOutlet weak var cityLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    cityLabel.textColor = .white
    self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

