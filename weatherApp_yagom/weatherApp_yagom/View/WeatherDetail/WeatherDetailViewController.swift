//
//  WeatherDetailViewController.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import UIKit

class WeatherDetailViewController: UIViewController {
  
  //MARK: - UI
  
  private var datasource: [String] = ["도시이름", "", "현재온도: ", "체감온도: ", "현재습도: ", "기압: ",
                                      "최고기온: ", "최저기온: ", "풍속: ", "오늘의 날씨는"]
  
  private var tableView = UITableView()
  lazy var futureWeatherButton: UIBarButtonItem = {
    let button = UIBarButtonItem(title: "미래날씨", style: .plain, target: self, action: #selector(gotoFutureWeatherVC(_:)))
    return button
  }()
  
  //MARK: - init

  public init(viewModel: WeatherDetailViewModel, futureWeatherViewControllerFactory: FutureWeatherViewControllerFactory, imageCacher: ImageCache) {
    self.imageCacher = imageCacher
    self.viewModel = viewModel
    self.futureWeatherViewControllerFactory = futureWeatherViewControllerFactory
    super.init(nibName: nil, bundle: nil)
    
    self.viewModel.updateUI = { [weak self] in
      guard let self = self else {return}
      DispatchQueue.main.async {
        self.datasource[0] = self.viewModel.cityName
        self.datasource[1] = self.viewModel.weatherInfo.imageUrl
        self.datasource[2] = "현재온도: \(self.viewModel.weatherInfo.temp)℃"
        self.datasource[3] = "체감온도: \(self.viewModel.weatherInfo.feelsLike)℃"
        self.datasource[4] = "현재습도: \(self.viewModel.weatherInfo.humidity)%"
        self.datasource[5] = "기압: \(self.viewModel.weatherInfo.pressure)hPa"
        self.datasource[6] = "최고온도: \(self.viewModel.weatherInfo.tempMax)℃"
        self.datasource[7] = "최저기온: \(self.viewModel.weatherInfo.tempMin)℃"
        self.datasource[8] = "풍속: \(self.viewModel.weatherInfo.windSpeed)m/s"
        self.datasource[9] = "오늘의 날씨는 \(self.viewModel.weatherInfo.description)"
        self.tableView.reloadData()
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
    setupBarbutton()
    setupTableView()
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.restartSync()
  }
  
  //MARK: - Private
  
  private var viewModel: WeatherDetailViewModel
  private var futureWeatherViewControllerFactory: FutureWeatherViewControllerFactory
  private weak var imageCacher: ImageCache?
  
  private func setupBarbutton() {
    navigationItem.rightBarButtonItem = futureWeatherButton
  }
  
  private func setupTableView() {
    
    tableView.separatorStyle = .none
    tableView.backgroundColor = .white
    tableView.register(WeatherDetailTableViewCell.self)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    
    tableView.delegate = self
    tableView.dataSource = self
    
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

//MARK: - Datasource

extension WeatherDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return datasource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDetailTableViewCell.identifier, for: indexPath) as? WeatherDetailTableViewCell else { return WeatherDetailTableViewCell()}
    
    if indexPath.row == 1 { //icon
      if datasource[indexPath.row] != "" {
        imageCacher?.getIcon(with: datasource[indexPath.row]) { (image) in
          if let image = image {
            cell.iconImageView.image = image
          }
        }
      }
      cell.stackView.alignment = .center
      cell.iconImageView.isHidden = false
      cell.titleLabel.text = nil
    } else {
      cell.iconImageView.isHidden = true
      cell.titleLabel.text = datasource[indexPath.row]
      cell.stackView.alignment = .leading
    }
    
    return cell
  }
  
}

//MARK: - Delegate

extension WeatherDetailViewController: UITableViewDelegate {
}
