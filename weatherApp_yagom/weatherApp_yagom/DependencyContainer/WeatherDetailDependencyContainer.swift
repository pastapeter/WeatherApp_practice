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
  
  public init(appDependencyContainer: WeatherMainDependencyContainer) {
    
    func makeWeatherDetailViewModel(weatherRepository: CurrentWeatherRepository) -> WeatherDetailViewModel {
      return WeatherDetailViewModel(weatherRepository: weatherRepository)
    }
    
    self.sharedWeatherRepository = appDependencyContainer.sharedWeatherRepository
    self.sharedWeatherDetailViewModel = makeWeatherDetailViewModel(weatherRepository: sharedWeatherRepository)
    
  }
  
  func makeWeatherDetailViewController() -> WeatherDetailViewController {
    return WeatherDetailViewController(viewModel: sharedWeatherDetailViewModel)
  }
}
