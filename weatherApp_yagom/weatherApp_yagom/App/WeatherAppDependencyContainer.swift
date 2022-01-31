//
//  WeatherAppDependencyContainer.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

public class WeatherAppDependencyContainer {
  
  //상태저장의존성
  let sharedWeatherSessionRepository: CurrentWeatherRepository
  let sharedWeatherMainViewModel: WeatherMainViewModel
  
  public init() {
    func makeCurrentWeatherRepository() -> CurrentWeatherRepository {
      let remoteAPI = makeWeatherRemoteAPI()
      return WeatherRepository(remoteAPI: remoteAPI)
    }
    
    func makeWeatherRemoteAPI() -> WeatherRemoteAPI {
      return MainWeatherRemoteAPI()
    }
    
    func makeWeatherMainViewModel() -> WeatherMainViewModel {
      return WeatherMainViewModel(currentWeatherRepository: makeCurrentWeatherRepository())
    }
    
    self.sharedWeatherMainViewModel = makeWeatherMainViewModel()
    self.sharedWeatherSessionRepository = makeCurrentWeatherRepository()
  }
  
  // WeatherMainViewController
  func makeWeatherMainViewController() -> WeatherMainViewController {
    return WeatherMainViewController(viewModel: sharedWeatherMainViewModel)
  }
  
  // WeatherDetail
  func makeWeatherDetailViewController() -> WeatherDetailViewController {
    let dependencyContainer = WeatherDetailDependencyContainer(appDependencyContainer: self)
    return dependencyContainer.makeWeatherDetailViewController()
  }
  
}
