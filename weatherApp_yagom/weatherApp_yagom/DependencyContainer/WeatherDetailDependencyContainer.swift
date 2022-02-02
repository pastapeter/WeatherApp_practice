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
  let imageCacher: ImageCache
  
  // 상태저장 의존성
  let sharedWeatherDetailViewModel: WeatherDetailViewModel
  
  public init(appDependencyContainer: WeatherMainDependencyContainer) {
    
    func makeWeatherDetailViewModel(weatherRepository: CurrentWeatherRepository) -> WeatherDetailViewModel {
      let selectedCity = appDependencyContainer.sharedWeatherMainViewModel.selectedCity
      return WeatherDetailViewModel(weatherRepository: weatherRepository, cityName: selectedCity)
    }
    
    self.sharedWeatherRepository = appDependencyContainer.sharedWeatherRepository
    self.imageCacher = appDependencyContainer.imageCache
    self.sharedWeatherDetailViewModel = makeWeatherDetailViewModel(weatherRepository: sharedWeatherRepository)
  }
  
  func makeWeatherDetailViewController() -> WeatherDetailViewController {
    return WeatherDetailViewController(viewModel: sharedWeatherDetailViewModel, futureWeatherViewControllerFactory: self, imageCacher: imageCacher)
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
