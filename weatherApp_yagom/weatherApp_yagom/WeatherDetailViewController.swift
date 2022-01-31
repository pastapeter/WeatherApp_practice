//
//  WeatherDetailViewController.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import UIKit

class WeatherDetailViewController: UIViewController {
  
  private var viewModel: WeatherDetailViewModel
  
  public init(viewModel: WeatherDetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
