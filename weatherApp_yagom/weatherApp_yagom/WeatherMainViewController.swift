//
//  ViewController.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/30.
//

import UIKit

final class WeatherMainViewController: UIViewController {
  
  //MARK: - UI

  private lazy var tableView: UITableView = {
    let tableview = UITableView()
    tableview.backgroundColor = .white
    tableview.register(WeatherMainTableViewCell.self)
    tableview.translatesAutoresizingMaskIntoConstraints = false
    return tableview
  }()

  //MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setTableView()
  }

  //MARK: - Private
  private var datasource: [CurrentWeatherCellModel] = []
  
  private func setTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    view.addSubview(tableView)
    tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
  }

}

//MARK: - Tableview datasource

extension WeatherMainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
//    return datasource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherMainTableViewCell.identifier, for: indexPath) as? WeatherMainTableViewCell else {return WeatherMainTableViewCell()}
    return cell
  }

}
//MARK: - Tableview delegate

extension WeatherMainViewController: UITableViewDelegate {
  
}

