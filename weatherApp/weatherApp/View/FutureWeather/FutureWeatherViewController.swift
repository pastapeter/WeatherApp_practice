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
    tableView.backgroundColor = .clear
    tableView.register(FutureWeatherTableViewCell.self)

    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(tableView)
    
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    tableView.topAnchor.constraint(equalTo: xButton.bottomAnchor, constant: 20).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    
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
    view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    setupXButton()
    setUptableView()
    // Do any additional setup after loading the view.
  }
  
  //MARK: - Viewmodel & bind
  var viewModel: FutureWeatherViewModel
  
  func bindViewModel() {
    viewModel.cityAndEntries
      .drive(onNext: { [weak self] cityName, entries in
        guard let self = self else {return}
        self.cityName = cityName
        self.tempMinEntry = entries.tempMin
        self.humidEntry = entries.humid
        self.tempMaxEntry = entries.tempMax
        self.tableView.reloadData()
      })
      .disposed(by: disposeBag)
    
    xButton.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .withUnretained(self)
      .subscribe(onNext: { vc, _ in
        vc.viewModel.viewwillDisappear()
        vc.dismiss(animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
  }
  
  //MARK: - Private
  private var disposeBag = DisposeBag()
  private var tempMaxEntry = [PointEntry]()
  private var humidEntry = [PointEntry]()
  private var tempMinEntry = [PointEntry]()
  private var cityName = ""
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
