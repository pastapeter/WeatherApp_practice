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

  public init(viewModel: WeatherDetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
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
  
  //MARK: - Private
  
  private var viewModel: WeatherDetailViewModel
  
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
    self.present(FutureWeatherViewController(), animated: true, completion: nil)
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
      cell.iconImageView.image = UIImage(systemName: "cloud.sun")
      cell.iconImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
      cell.stackView.alignment = .center
      cell.titleLabel.text = nil
    } else { //
      cell.iconImageView.image = nil
      cell.titleLabel.text = datasource[indexPath.row]
      if indexPath.row != 0 {
        cell.titleLabel.font = .preferredFont(forTextStyle: .body)
      }
    }
    
    return cell
  }
  
}

//MARK: - Delegate

extension WeatherDetailViewController: UITableViewDelegate {
}
