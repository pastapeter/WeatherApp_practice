//
//  WeatherDetailViewController.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherDetailViewController: UIViewController, ViewModelBindableType {
  
  //MARK: - UI
  
  private var titlePrefix: [String] = ["", "", "현재온도: ", "체감온도: ", "현재습도: ", "기압: ",
                                      "최고기온: ", "최저기온: ", "풍속: ", "오늘의 날씨는 "]
  
  private var tableView = UITableView()
  lazy var futureWeatherButton: UIBarButtonItem = {
    let button = UIBarButtonItem(title: "미래날씨", style: .plain, target: self, action: #selector(gotoFutureWeatherVC(_:)))
    return button
  }()

  //MARK: - Binding
  
  func bindViewModel() {
    viewModel.weatherInfo
      .drive(tableView.rx.items(cellIdentifier: WeatherDetailTableViewCell.identifier, cellType: WeatherDetailTableViewCell.self)) { [weak self] (index, element, cell) in
        guard let self = self else {return}
        if index == 1 {
          self.imageCacher.getIcon(with: self.titlePrefix[index] + element) { (image) in
            if let image = image {
              cell.iconImageView.image = image
            }
          }
          cell.stackView.alignment = .center
          cell.iconImageView.isHidden = false
          cell.titleLabel.text = nil
        } else {
          cell.titleLabel.text = self.titlePrefix[index] + element
          cell.iconImageView.isHidden = true
          cell.stackView.alignment = .leading
        }
      }
      .disposed(by: disposeBag)
  }

  //MARK: - init

  public init(viewModel: WeatherDetailViewModel, futureWeatherViewControllerFactory: FutureWeatherViewControllerFactory, imageCacher: ImageCache) {
    self.imageCacher = imageCacher
    self.viewModel = viewModel
    self.futureWeatherViewControllerFactory = futureWeatherViewControllerFactory
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
    setupBarbutton()
    setupTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.restartSync()
  }
  
  //MARK: - Private
  
  var viewModel: WeatherDetailViewModel
  private var futureWeatherViewControllerFactory: FutureWeatherViewControllerFactory
  private var imageCacher: ImageCache
  private var disposeBag = DisposeBag()
  
  private func setupBarbutton() {
    navigationItem.rightBarButtonItem = futureWeatherButton
  }
  
  private func setupTableView() {
    
    tableView.separatorStyle = .none
    tableView.backgroundColor = .white
    tableView.register(WeatherDetailTableViewCell.self)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
  }
  
  @objc private func gotoFutureWeatherVC(_ sender: Any) {
    viewModel.stopSync()
    let vc = futureWeatherViewControllerFactory.makeFutureWeatherViewController()
    self.present(vc, animated: true, completion: nil)
  }
  
}

