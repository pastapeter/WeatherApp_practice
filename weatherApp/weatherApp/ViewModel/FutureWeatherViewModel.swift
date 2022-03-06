//
//  FutureWeatherViewModel.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/02/01.
//

import Foundation
import RxSwift
import RxCocoa

final class FutureWeatherViewModel {
  
  let city: String
  
  public init(futureWeatherRepository: FutureWeatherRepository, cityName: String) {
    self.futureWeatherRepository = futureWeatherRepository
    self.city = cityName
  }
  
  func viewwillDisappear() {
    disposeBag = DisposeBag()
  }
  
  func restartSync() {
  }
  
  private var forecastInfoArr: Driver<[(time: String, tempMax: Double, tempMin: Double, humid: Double)]> {
    
    let forecastInfoRelay = PublishRelay<[(time: String, tempMax: Double, tempMin: Double, humid: Double)]>()
    
    // 1분마다 배열에 첫시간과 비교, 현재시간이 배열의 첫시간보다 클 경우, 갱신
    let timeFilterObservable = Observable<Int>
      .timer(.seconds(0), period: .seconds(60), scheduler: MainScheduler.instance)
      .filter { [unowned self] _ in
        if !self.forecast.isEmpty {
          if let recent = self.forecast[0].time.toDate(format: "MM/dd HH:mm"), recent >= Date() {
            return true
          } else {
            return false
          }
        }
        return true
      }
    
    timeFilterObservable
      .withUnretained(self)
      .subscribe(onNext: { (viewmodel, index) in
        viewmodel.futureWeatherRepository.futureWeather(in: viewmodel.city)
          .map { futureWeather -> [(time: String, tempMax: Double, tempMin: Double, humid: Double)] in
            var temp = [(time: String, tempMax: Double, tempMin: Double, humid: Double)]()
            futureWeather.list.forEach {
              temp.append((time: $0.date.forMattingDate(),
                           tempMax: $0.main.tempMax,
                           tempMin: $0.main.tempMin,
                           humid: $0.main.humidity
                          ))
            }
            return temp
          }
          .bind(to: forecastInfoRelay)
          .disposed(by: viewmodel.disposeBag)
      })
      .disposed(by: disposeBag)
    
    return forecastInfoRelay
      .asDriver(onErrorJustReturn: [])
  }
  
  var cityAndEntries: Driver<(String, (tempMax: [PointEntry], tempMin: [PointEntry], humid: [PointEntry]))> {
    
    let left: Observable<String> = Observable.just(city)
    
    let right = forecastInfoArr
      .asObservable()
      .flatMap { arr -> Observable<(tempMax: [PointEntry], tempMin: [PointEntry], humid: [PointEntry])> in
        let minEntry = arr.map { PointEntry(value: $0.tempMin, label: $0.time)}
        let maxEntry = arr.map { PointEntry(value: $0.tempMax, label: $0.time)}
        let humidArr = arr.map { PointEntry(value: $0.humid, label: $0.time)}
        return Observable.just((tempMax: maxEntry, tempMin: minEntry, humid: humidArr))
      }
    
    let zip = Observable
      .zip(left, right)
      .asDriver(onErrorJustReturn: ("", ([], [], [])))
    
    return zip
      
  }
  
  //MARK: - Private
  
  private var futureWeatherRepository: FutureWeatherRepository
  private var forecast: [(time: String, tempMax: Double, tempMin: Double, humid: Double)] = []
  private var disposeBag = DisposeBag()
  
  enum EntryType {
    case tempMin
    case tempMax
    case humid
  }

}

