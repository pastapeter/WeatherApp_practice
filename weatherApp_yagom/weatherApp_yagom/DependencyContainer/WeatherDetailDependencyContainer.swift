//
//  WeatherDetailDependencyContainer.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

final class WeatherDetailDependencyContainer {
  
  // 부모 container로부터 받는 의존성
  let sharedWeatherRepository: CurrentWeatherRepository
  
  // 상태저장 의존성
  let sharedWeatherDetailViewModel: WeatherDetailViewModel
  
  public init(appDependencyContainer: WeatherMainDependencyContainer, cityName: String) {
    
    func makeWeatherDetailViewModel(weatherRepository: CurrentWeatherRepository, cityName: String) -> WeatherDetailViewModel {
      return WeatherDetailViewModel(weatherRepository: weatherRepository, cityName: cityName)
    }
    
    self.sharedWeatherRepository = appDependencyContainer.sharedWeatherRepository
    self.sharedWeatherDetailViewModel = makeWeatherDetailViewModel(weatherRepository: sharedWeatherRepository, cityName: cityName)
    
  }
  
  func makeWeatherDetailViewController() -> WeatherDetailViewController {
    return WeatherDetailViewController(viewModel: sharedWeatherDetailViewModel, futureWeatherViewControllerFactory: self)
  }
  
  // FutureWeather
  func makeFutureWeatherViewController() -> FutureWeatherViewController {
    let dependencyContainer = FutureWeatherDependencyContainer(appDependencyContainer: self, cityName: sharedWeatherDetailViewModel.cityName)
    return dependencyContainer.makeFutureWeatherViewController()
  }
  
}

extension WeatherDetailDependencyContainer: FutureWeatherViewControllerFactory {}

protocol FutureWeatherViewControllerFactory {
  func makeFutureWeatherViewController() -> FutureWeatherViewController
}
