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
      let coder = makeNetworkCoder()
      return MainWeatherRemoteAPI(coder: coder)
    }
    
    func makeNetworkCoder() -> NetworkCoding {
      return NetworkCoder()
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
  
  func makeWeatherDetailViewController() -> WeatherDetailViewController {
    let dependencyContainer = makeWeatherDetailDependencyContainer()
    return dependencyContainer.makeWeatherDetailViewController()
  }
    
  func makeWeatherDetailDependencyContainer() -> WeatherDetailDependencyContainer {
    return WeatherDetailDependencyContainer(appDependencyContainer: self)
  }

}

extension WeatherMainDependencyContainer: WeatherDetailViewControllerFactory { }

protocol WeatherDetailViewControllerFactory {
  func makeWeatherDetailViewController() -> WeatherDetailViewController
}
