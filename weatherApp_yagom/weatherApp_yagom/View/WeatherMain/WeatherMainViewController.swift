//
//  ViewController.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/30.
//

import UIKit
import RxSwift
import RxCocoa

final class WeatherMainViewController: UIViewController, ViewModelBindableType {
  
  //MARK: - UI

  private lazy var tableView: UITableView = {
    let tableview = UITableView()
    tableview.backgroundColor = .white
    tableview.register(WeatherMainTableViewCell.self)
    tableview.translatesAutoresizingMaskIntoConstraints = false
    return tableview
  }()
  
  //MARK: - Binding
  
  func bindViewModel() {
    
    viewModel.weatherInfo
      .drive(tableView.rx.items(cellIdentifier: WeatherMainTableViewCell.identifier, cellType: WeatherMainTableViewCell.self)) { [weak self] (index, element, cell) in
        cell.bind(cellModel: element)
        self?.imageCache.getIcon(with: element.imageUrl, completion: { (image) in
          if let image = image {
            cell.weatherImageView.image = image
          }
        })
      }
      .disposed(by: disposeBag)
    
    tableView.rx.modelSelected(WeatherMainCellModel.self)
      .subscribe(onNext: { [weak self] in
        guard let self = self else {return}
        self.viewModel.select(item: $0)
        self.navigationController?
          .pushViewController(self.makeWeatherDetailVCFactory
          .makeWeatherDetailViewController(selectedCity: self.viewModel.selectedCity),
                              animated: true)
      })
      .disposed(by: disposeBag)
    
  }
  
  //MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setTableView()
  }

  //MARK: - Private
  private var datasource: [WeatherMainCellModel] = []
  var viewModel: WeatherMainViewModel
  
  //factory
  private let makeWeatherDetailVCFactory: WeatherDetailViewControllerFactory
  
  //imageCache
  private var imageCache: ImageCache
  
  //disposebag
  private var disposeBag = DisposeBag()
  
  public init(viewModel: WeatherMainViewModel, weatherDetailViewControllerFactory: WeatherDetailViewControllerFactory, imageCache: ImageCache) {
    self.viewModel = viewModel
    self.makeWeatherDetailVCFactory = weatherDetailViewControllerFactory
    self.imageCache = imageCache
    super.init(nibName: nil, bundle: nil)
    bind(viewModel: self.viewModel)
  }
  
  required public init?(coder: NSCoder) {
    fatalError("이 뷰컨트롤러는 코드베이스입니다.")
  }
  
  private func setTableView() {
    view.addSubview(tableView)
    tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
  }
  
  deinit {
    print(self, "사라졌습니다.")
  }

}

