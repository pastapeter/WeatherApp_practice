//
//  WeatherDetailDependencyContainer.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

final class WeatherDetailDependencyContainer {
  
  // 부모 container로부터 받는 의존성
  let sharedWeatherSessionRepository: CurrentWeatherRepository
  
  // 상태저장 의존성
  let sharedWeatherDetailViewModel: WeatherDetailViewModel
  
  public init(appDependencyContainer: WeatherAppDependencyContainer) {
    func makeWeatherDetailViewModel() -> WeatherDetailViewModel {
      return WeatherDetailViewModel()
    }
    
    self.sharedWeatherSessionRepository = appDependencyContainer.sharedWeatherSessionRepository
    self.sharedWeatherDetailViewModel = makeWeatherDetailViewModel()
    
  }
  
  func makeWeatherDetailViewController() -> WeatherDetailViewController {
    return WeatherDetailViewController(viewModel: sharedWeatherDetailViewModel)
  }
}
