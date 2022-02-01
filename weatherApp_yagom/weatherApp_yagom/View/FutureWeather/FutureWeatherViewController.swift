//
//  FutureWeatherViewController.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/02/01.
//

import UIKit

class FutureWeatherViewController: UIViewController {
  
  //MARK: - UI
  
  private let tableView = UITableView()
  lazy var xButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(systemName: "xmark"), for: .normal)
    button.addTarget(self, action: #selector(dismissVC(_:)), for: .touchUpInside)
    return button
  }()
  
  private func setupXButton() {
    view.addSubview(xButton)
    xButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
    xButton.heightAnchor.constraint(equalTo: xButton.widthAnchor).isActive = true
    xButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    xButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
  }
  
  private func setUptableView() {
    
    tableView.separatorStyle = .none
    tableView.register(FutureWeatherTableViewCell.self)
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(tableView)
    
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    tableView.topAnchor.constraint(equalTo: xButton.bottomAnchor, constant: 20).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    
  }
  
  @objc private func dismissVC(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  //MARK: - Init
  
  init(viewModel: FutureWeatherViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    viewModel.updateUI = {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else {return}
        self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupXButton()
    setUptableView()
    // Do any additional setup after loading the view.
  }
  
  
  //MARK: - Private
  private var viewModel: FutureWeatherViewModel
  
  private func generateMaxTempEntries() -> [PointEntry] {
    var result: [PointEntry] = []
    result = viewModel.forecast.map {
      PointEntry(value: $0.tempMax, label: $0.time)
    }
    return result
  }
  
  private func generateMinTempEntries() -> [PointEntry] {
    var result: [PointEntry] = []
    result = viewModel.forecast.map {
      PointEntry(value: $0.tempMin, label: $0.time)
    }
    return result
  }
  
  private func generateHumidEntries() -> [PointEntry] {
    var result: [PointEntry] = []
    result = viewModel.forecast.map {
      PointEntry(value: $0.humid, label: $0.time)
    }
    return result
  }
  
}

extension FutureWeatherViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: FutureWeatherTableViewCell.identifier, for: indexPath) as? FutureWeatherTableViewCell else {return FutureWeatherTableViewCell()}
    
    if indexPath.row == 0 {
      cell.lineChart.isHidden = true
      cell.cityLabel.text = self.viewModel.cityname
    } else {
      cell.cityLabel.text = nil
      cell.lineChart.isHidden = false
      cell.lineChart.maxTempDataEntries = generateMaxTempEntries()
      cell.lineChart.humidDataEntries = generateHumidEntries()
      cell.lineChart.minTempDataEntries = generateMinTempEntries()
    }
    
    return cell
  }
  
  
}

extension FutureWeatherViewController: UITableViewDelegate {
  
}
