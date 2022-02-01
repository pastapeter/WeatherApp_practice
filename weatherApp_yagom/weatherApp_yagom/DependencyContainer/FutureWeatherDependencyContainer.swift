//
//  FutureWeatherDependencyContainer.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/02/01.
//

import Foundation

final class FutureWeatherDependencyContainer {
  
  //부모로부터받은 의존성
  
  //상태 저장 의존성
  let sharedFutureWeatherRepository: FutureWeatherRepository
  let sharedFutureWeatherViewModel: FutureWeatherViewModel
  
  init(appDependencyContainer: WeatherDetailDependencyContainer, cityName: String) {
    
    func makeWeatherRemoteAPI() -> WeatherRemoteAPI {
      return MainWeatherRemoteAPI()
    }
    
    func makeFutureWeatherRepository() -> FutureWeatherRepository {
      let remoteAPI = makeWeatherRemoteAPI()
      return WeatherRepository(remoteAPI: remoteAPI)
    }
    
    let repository = makeFutureWeatherRepository()
    
    func makeFutureWeatherViewModel(cityName: String) -> FutureWeatherViewModel {
      return FutureWeatherViewModel(futureWeatherRepository: repository, cityName: cityName)
    }
    
    self.sharedFutureWeatherRepository = repository
    self.sharedFutureWeatherViewModel = makeFutureWeatherViewModel(cityName: cityName)
    
  }
  
  func makeFutureWeatherViewController() -> FutureWeatherViewController {
    return FutureWeatherViewController(viewModel: sharedFutureWeatherViewModel)
  }
  
}
