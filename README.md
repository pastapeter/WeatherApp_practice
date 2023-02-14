# WeatherApp

<img width="644" alt="스크린샷 2022-02-28 오후 9 57 57" src="https://user-images.githubusercontent.com/69891604/155987406-01585167-1a90-4c5e-8c2d-2bd3eaa0331b.png">


## WeatherApp 버전
- WeatherApp_First: Unit Test, MVVM, Repository Pattern
- WeatherApp: Rxswift, MVVM, Repository Pattern

## WeatherApp의 목표(1차)
1. Dependency Container를 사용해서 의존성 주입하기 :white_check_mark:
2. 의존성 역치를 통해서 Testable한 코드 작성하기 :white_check_mark:
3. Repository Pattern 사용하기 :white_check_mark:
4. MVVM으로 작성하기 :white_check_mark:

## WeatherApp의 목표(2차)
1. Rxswift으로 바꿔보기 :white_check_mark:
2. Coordinator 적용하기(MVVM-C) 
3. Test code 작성해보기 :white_check_mark:


## WeatherApp의 목표(3차)
1. not Yet

## Foldering
```bash
├── App
│   ├── AppDelegate.swift
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   └── Contents.json
│   │   └── Contents.json
│   ├── Base.lproj
│   │   └── LaunchScreen.storyboard
│   ├── Info.plist
│   └── SceneDelegate.swift
├── DependencyContainer
│   ├── FutureWeatherDependencyContainer.swift
│   ├── WeatherDetailDependencyContainer.swift
│   └── WeatherMainDependencyContainer.swift
├── Model
│   ├── CityName.swift
│   ├── CurrentWeather.swift
│   ├── Forecast.swift
│   ├── FutureWeather.swift
│   ├── MainWeatherInfo.swift
│   ├── Weather.swift
│   └── Wind.swift
├── RemoteAPI
│   ├── MainWeatherRemoteAPI.swift
│   └── WeatherRemoteAPI.swift
├── Repository
│   ├── CurrentWeatherRepository.swift
│   ├── FutureWeatherRepository.swift
│   └── WeatherRepository.swift
├── Utility
│   ├── DateUtils
│   │   └── Date+Extension.swift
│   ├── ImageCache
│   │   ├── ImageCache.swift
│   │   └── ImageCacher.swift
│   ├── NetworkUtils
│   │   ├── APIInfo.swift
│   │   ├── NetworkCoder.swift
│   │   ├── NetworkCoding.swift
│   │   ├── NetworkError.swift
│   │   └── NetworkRequest.swift
│   ├── StringUtils
│   │   └── String+Extension.swift
│   └── ViewUtils
│       ├── LineChart.swift
│       ├── NibLoadableView.swift
│       ├── PointEntry.swift
│       ├── ReusableView.swift
│       ├── UITableView+Extension.swift
│       └── UIView+Extension.swift
├── View
│   ├── FutureWeather
│   │   ├── FutureWeatherTableViewCell.swift
│   │   ├── FutureWeatherTableViewCell.xib
│   │   └── FutureWeatherViewController.swift
│   ├── FutureWeatherViewController.swift
│   ├── WeatherDetail
│   │   ├── WeatherDetailTableViewCell.swift
│   │   └── WeatherDetailViewController.swift
│   └── WeatherMain
│       ├── WeatherMainTableViewCell.swift
│       ├── WeatherMainTableViewCell.xib
│       └── WeatherMainViewController.swift
└── ViewModel
    ├── FutureWeatherViewModel.swift
    ├── ViewModelBindableType.swift
    ├── WeatherDetailViewModel.swift
    ├── WeatherMainCellModel.swift
    └── WeatherMainViewModel.swift
```


## 아키텍쳐 & 패턴 적용기
- [DI Container 적용기](https://github.com/pastapeter/WeatherApp_practice/blob/master/DependencyContainer%EC%A0%81%EC%9A%A9%ED%95%98%EA%B8%B0.md)
- [Repository Pattern 적용기]


## 트러블 슈팅
- [객체들이 deinit이 안된다..? Nested Closore 이야기](https://guttural-tumble-39b.notion.site/Memory-Leak-7546ddb167b541d7b5c02d97f6cdec64)
- [RootViewController의 Timer가 있을 때, Dispose를 해야하는가?](https://github.com/pastapeter/WeatherApp_practice/blob/master/RootViewController%EC%9D%98%20Timer%EA%B0%80%20%EC%9E%88%EC%9D%84%20%EB%95%8C%2C%20Dispose%EB%A5%BC%20%ED%95%B4%EC%95%BC%ED%95%98%EB%8A%94%EA%B0%80%3F.md)
