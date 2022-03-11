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
    
    func makeImageCache() -> ImageCache {
      return ImageCacher(networkRequest: NetworkRequest(session: URLSession.init(configuration: .ephemeral)))
    }
    
    self.imageCache = makeImageCache()
    self.sharedWeatherRepository = makeCurrentWeatherRepository()
  }
  
  func makeWeatherMainViewModel() -> WeatherMainViewModel {
    #if targetEnvironment(simulator)
    return WeatherMainViewModel(currentWeatherRepository: MockCurrentWeatherRepository())
    #else
    return WeatherMainViewModel(currentWeatherRepository: sharedWeatherRepository)
    #endif
  }
  
  // WeatherMainViewController
  func makeWeatherMainViewController() -> WeatherMainViewController {
    let viewModel = makeWeatherMainViewModel()
    return WeatherMainViewController(viewModel: viewModel, weatherDetailViewControllerFactory: self , imageCache: imageCache)
  }
  
  // WeatherDetail
  
  func makeWeatherDetailViewController(selectedCity: String) -> WeatherDetailViewController {
    let dependencyContainer = WeatherDetailDependencyContainer(selectedCity: selectedCity, appDependencyContainer: self)
    return dependencyContainer.makeWeatherDetailViewController()
  }

}

extension WeatherMainDependencyContainer: WeatherDetailViewControllerFactory { }

protocol WeatherDetailViewControllerFactory: AnyObject {
  func makeWeatherDetailViewController(selectedCity: String) -> WeatherDetailViewController
}


