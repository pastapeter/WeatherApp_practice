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
    viewModel.updatedUI = { [weak self] in
      guard let self = self else {return}
      DispatchQueue.main.async {
        self.datasource = self.viewModel.datasource
        self.tableView.reloadData()
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    viewModel.restartSync()
  }

  //MARK: - Private
  private var datasource: [WeatherMainCellModel] = []
  private let viewModel: WeatherMainViewModel
  
  //factory
  private let makeWeatherDetailVCFactory: WeatherDetailViewControllerFactory
  
  //imageCache
  private var imageCache: ImageCache
  
  public init(viewModel: WeatherMainViewModel, weatherDetailViewControllerFactory: WeatherDetailViewControllerFactory, imageCache: ImageCache) {
    self.viewModel = viewModel
    self.makeWeatherDetailVCFactory = weatherDetailViewControllerFactory
    self.imageCache = imageCache
    super.init(nibName: nil, bundle: nil)
  }
  
  required public init?(coder: NSCoder) {
    fatalError("이 뷰컨트롤러는 코드베이스입니다.")
  }
  
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
    return datasource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherMainTableViewCell.identifier, for: indexPath) as? WeatherMainTableViewCell else {return WeatherMainTableViewCell()}
    cell.bind(cellModel: datasource[indexPath.row])
    imageCache.getIcon(with: datasource[indexPath.row].imageUrl, completion: { (image) in
      if let image = image {
        cell.weatherImageView.image = image
      }
    })
    return cell
  }

}
//MARK: - Tableview delegate

extension WeatherMainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.stopSync()
    let cityName = datasource[indexPath.row].name
    viewModel.selectedCity = cityName
//    let vc = makeWeatherDetailVCFactory.makeWeatherDetailViewController(cityName: cityName)
    let vc = makeWeatherDetailVCFactory.makeWeatherDetailViewController()
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

