//
//  FutureWeatherViewController.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/02/01.
//

import UIKit
import RxSwift

class FutureWeatherViewController: UIViewController, ViewModelBindableType {

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
    tableView.dataSource = self
    tableView.register(FutureWeatherTableViewCell.self)

    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(tableView)
    
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    tableView.topAnchor.constraint(equalTo: xButton.bottomAnchor, constant: 20).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    
  }
  
  @objc private func dismissVC(_ sender: Any) {
    viewModel.stopSync()
    self.dismiss(animated: true, completion: nil)
  }
  
  //MARK: - Init
  
  init(viewModel: FutureWeatherViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    bind(viewModel: self.viewModel)
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
  
  //MARK: - Viewmodel & bind
  var viewModel: FutureWeatherViewModel
  
  func bindViewModel() {
    viewModel.entries
      .drive(onNext: { [weak self] in
        self?.tempMinEntry = $0.tempMin
        self?.humidEntry = $0.humid
        self?.tempMaxEntry = $0.tempMax
        self?.tableView.reloadData()
      })
      .disposed(by: disposeBag)
  }
  
  //MARK: - Private
  private var disposeBag = DisposeBag()
  private var tempMaxEntry = [PointEntry]()
  private var humidEntry = [PointEntry]()
  private var tempMinEntry = [PointEntry]()
}

extension FutureWeatherViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: FutureWeatherTableViewCell.identifier, for: indexPath) as? FutureWeatherTableViewCell else {return FutureWeatherTableViewCell()}
    
    if indexPath.row == 0 {
      cell.lineChart.isHidden = true
      cell.cityLabel.text = self.viewModel.city
    } else {
      cell.cityLabel.text = nil
      cell.lineChart.isHidden = false
      cell.lineChart.humidDataEntries = humidEntry
      cell.lineChart.minTempDataEntries = tempMinEntry
      cell.lineChart.maxTempDataEntries = tempMaxEntry
    }
    return cell
  }

}

extension FutureWeatherViewController: UITableViewDelegate {
  
}
