//
//  WeatherAppDependencyContainer.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/01/31.
//

import Foundation

public class WeatherMainDependencyContainer {
  
  //상태저장의존성
  let sharedWeatherRepository: CurrentWeatherRepository
  let sharedWeatherMainViewModel: WeatherMainViewModel
  let imageCache: ImageCache
  
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
    
    func makeImageCache() -> ImageCache {
      return ImageCacher()
    }
    
    self.imageCache = makeImageCache()
    self.sharedWeatherMainViewModel = makeWeatherMainViewModel()
    self.sharedWeatherRepository = makeCurrentWeatherRepository()
  }
  
  // WeatherMainViewController
  func makeWeatherMainViewController() -> WeatherMainViewController {
    
    return WeatherMainViewController(viewModel: sharedWeatherMainViewModel, weatherDetailViewControllerFactory: self , imageCache: imageCache)
  }
  
  // WeatherDetail
  func makeWeatherDetailViewController(cityName: String) -> WeatherDetailViewController {
    let dependencyContainer = makeWeatherDetailDependencyContainer(cityName: cityName)
    return dependencyContainer.makeWeatherDetailViewController()
  }
  
  func makeWeatherDetailDependencyContainer(cityName: String) -> WeatherDetailDependencyContainer {
    return WeatherDetailDependencyContainer(appDependencyContainer: self, cityName: cityName)
  }

}

extension WeatherMainDependencyContainer: WeatherDetailViewControllerFactory { }

protocol WeatherDetailViewControllerFactory {
  func makeWeatherDetailViewController(cityName: String) -> WeatherDetailViewController
}
