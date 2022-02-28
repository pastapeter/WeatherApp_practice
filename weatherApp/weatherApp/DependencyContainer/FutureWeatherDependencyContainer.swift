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
  
  //context
  let cityName: String
  
  init(selectedCity: String, appDependencyContainer: WeatherDetailDependencyContainer) {
    
    func makeWeatherRemoteAPI() -> WeatherRemoteAPI {
      let coder = makeNetworkCoder()
      return MainWeatherRemoteAPI(coder: coder)
    }
    
    func makeNetworkCoder() -> NetworkCoding {
      return NetworkCoder()
    }
    
    func makeFutureWeatherRepository() -> FutureWeatherRepository {
      let remoteAPI = makeWeatherRemoteAPI()
      return WeatherRepository(remoteAPI: remoteAPI)
    }
  
    let repository = makeFutureWeatherRepository()
    self.cityName = selectedCity
    self.sharedFutureWeatherRepository = repository
    
  }
  
  func makeFutureWeatherViewModel() -> FutureWeatherViewModel {
    return FutureWeatherViewModel(futureWeatherRepository: sharedFutureWeatherRepository, cityName: cityName)
  }
  
  func makeFutureWeatherViewController() -> FutureWeatherViewController {
    let viewModel = makeFutureWeatherViewModel()
    return FutureWeatherViewController(viewModel: viewModel)
  }
  
}

