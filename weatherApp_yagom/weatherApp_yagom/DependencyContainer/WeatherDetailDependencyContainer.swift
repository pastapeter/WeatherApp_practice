//
//  WeatherDetailDependencyContainer.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

final class WeatherDetailDependencyContainer {
  
  let sharedWeatherRepository: CurrentWeatherRepository
  let imageCacher: ImageCache
  let selectedCity: String
  
  public init(selectedCity: String, appDependencyContainer: WeatherMainDependencyContainer) {
    self.selectedCity = selectedCity
    self.sharedWeatherRepository = appDependencyContainer.sharedWeatherRepository
    self.imageCacher = appDependencyContainer.imageCache
  }
  
  func makeWeatherDetailViewModel(weatherRepository: CurrentWeatherRepository) -> WeatherDetailViewModel {
    return WeatherDetailViewModel(weatherRepository: weatherRepository, cityName: selectedCity)
  }
  
  func makeWeatherDetailViewController() -> WeatherDetailViewController {
    let viewModel = makeWeatherDetailViewModel(weatherRepository: sharedWeatherRepository)
    return WeatherDetailViewController(viewModel: viewModel, futureWeatherViewControllerFactory: self, imageCacher: imageCacher)
  }
  
  // FutureWeather
  func makeFutureWeatherViewController() -> FutureWeatherViewController {
    let dependencyContainer = FutureWeatherDependencyContainer(selectedCity: selectedCity, appDependencyContainer: self)
    return dependencyContainer.makeFutureWeatherViewController()
  }
  
}

extension WeatherDetailDependencyContainer: FutureWeatherViewControllerFactory {}

protocol FutureWeatherViewControllerFactory: AnyObject {
  func makeFutureWeatherViewController() -> FutureWeatherViewController
}

