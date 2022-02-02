# WeatherApp_정도현

## 프로젝트 설명

### Dependency Containers

WeatherApp_정도현에는 DependencyContainer는 3개가 존재합니다. `WeatherMainDependency`가 최상위 DependencyContainer이고, 아래로 내려갈수록 하위 DependencyContainer로 볼 수 있습니다. 하위 컨테이너로 넘어가면서, 부모로부터 필요한 의존성을 받을뿐 아니라, 새롭게 필요한 의존성을 만들어서, 만들어야할 객체에 주입합니다.

![Untitled](WeatherApp_%E1%84%8C%E1%85%A5%E1%86%BC%E1%84%83%E1%85%A9%E1%84%92%E1%85%A7%E1%86%AB%203793062194514294baf029c6c64ce2d5/Untitled.png)

## `WeatherMainDependencyContainer`

`WeatherMainViewController`가 보여질 수 있도록 필요한 의존성을 주입해주는 DI Container입니다.  이 컨테이너에서는 아래와 같은 의존성 그래프가 그려진다. 

![Untitled](WeatherApp_%E1%84%8C%E1%85%A5%E1%86%BC%E1%84%83%E1%85%A9%E1%84%92%E1%85%A7%E1%86%AB%203793062194514294baf029c6c64ce2d5/Untitled%201.png)

### `WeatherRepository`

![Untitled](WeatherApp_%E1%84%8C%E1%85%A5%E1%86%BC%E1%84%83%E1%85%A9%E1%84%92%E1%85%A7%E1%86%AB%203793062194514294baf029c6c64ce2d5/Untitled%202.png)

Repository Pattern을 활용해서 `WeatherRepository` 를 사용하는 특정 객체(`WeatherMainViewModel`)이 데이터가 어디서 오는지 모르면서, 데이터를 fetch할 수 있게 만들었다. 

### `WeatherMainViewController`

![Untitled](WeatherApp_%E1%84%8C%E1%85%A5%E1%86%BC%E1%84%83%E1%85%A9%E1%84%92%E1%85%A7%E1%86%AB%203793062194514294baf029c6c64ce2d5/Untitled%203.png)

`WeatherMainViewController`는 `WeatherMainViewModel`, 이미지를 캐싱할수 있는  `ImageCache`, `WeatherDetailViewController`를 만들 수 있는 Factory Method를 의존성으로 가진다.  그리고 `WeatherMainViewModel`은 현재 날씨를 가져올 수 있는 `CurrentWeatherRepository`를 의존성으로 가진다. 

`WeatherMainViewModel`은 `CurrentWeatherRepository`에서 3초마다 데이터를 가져와서 현재 날씨를 계속 동기화한다. 이러한 동기화된 데이터를 `WeatherMainViewController`에서 아이콘을 보여줄 때, `ImageCache` 구현체를 활용해서 이미지를 캐싱을 사용했고, 그리고 `WeatherMainViewController`에서 `WeatherDetailViewController`로 화면전환이 필요할시, `WeatherDetailViewControllerFactory`를 사용해서 만들고 네이게이션을 활용해서 화면전환을 했다.

### WeatherMain화면

![Simulator Screen Shot - iPhone 13 - 2022-02-02 at 16.09.22.png](WeatherApp_%E1%84%8C%E1%85%A5%E1%86%BC%E1%84%83%E1%85%A9%E1%84%92%E1%85%A7%E1%86%AB%203793062194514294baf029c6c64ce2d5/Simulator_Screen_Shot_-_iPhone_13_-_2022-02-02_at_16.09.22.png)

## `WeatherDetailDependencyContainer`

![Untitled](WeatherApp_%E1%84%8C%E1%85%A5%E1%86%BC%E1%84%83%E1%85%A9%E1%84%92%E1%85%A7%E1%86%AB%203793062194514294baf029c6c64ce2d5/Untitled%204.png)

`WeatherMainViewController`에서 `WeatherDetailViewController`로 전환될 때, FactoryMethod로 인해서 `WeatherDetailDependencyContainer`가 생기고, 이를 통해서 `WeatherDetailViewController`와 관련된 모든 의존성 그래프가 그려지면서, 주입된다.

`WeatherDetailViewModel`에서도 역시 3초마다 Repository로부터 데이터를 받아오면서, `WeatherDetailViewController`의 UI를 저절로 변경시킨다. 

그리고 미래 날씨를 누르게 되면, Modal 형태로, `FutureWeatherViewController`를 띄우게 했다.

### WeatherDetail화면

![Simulator Screen Shot - iPhone 13 - 2022-02-02 at 16.09.27.png](WeatherApp_%E1%84%8C%E1%85%A5%E1%86%BC%E1%84%83%E1%85%A9%E1%84%92%E1%85%A7%E1%86%AB%203793062194514294baf029c6c64ce2d5/Simulator_Screen_Shot_-_iPhone_13_-_2022-02-02_at_16.09.27.png)

## `FutureWeatherDependencyContainer`

![Untitled](WeatherApp_%E1%84%8C%E1%85%A5%E1%86%BC%E1%84%83%E1%85%A9%E1%84%92%E1%85%A7%E1%86%AB%203793062194514294baf029c6c64ce2d5/Untitled%205.png)

`FutureWeatherViewController`에서는 `FutureWeatherViewModel`을 의존, `FutureWeatherViewModel`은 `FutureWeatherRepository`를 의존한다. `FutureWeatherViewModel`에서는 `FutureWeatherViewController`에서 그려줄 꺽은선 그래프를 그리는 데 필요한 정보들을 정제해서 제공한다. 이 데이터는 `FutureWeatherTableViewCell`에 @IBOutlet으로 정의되어있는 lineChart에 바인딩된다. 

`FutureWeatherViewModel`의 `syncWeather()`이라는 함수는 다른 ViewModel과는 다르게 매 초마다 데이터를 요구하지않는다. 1분마다 현재 날짜와 미리캐싱한 데이터(viewModel에서 상태를 저장하고 있다.)를 비교한다. 그리고 만약 미리 캐싱한 데이터의 첫 데이터의 날짜 및 시간이, 현재 날짜 및 시간보다 늦을때, 즉 일기예보가 되지 않을떄 다시 데이터를 요청한다.

![Simulator Screen Shot - iPhone 13 - 2022-02-02 at 00.57.04.png](WeatherApp_%E1%84%8C%E1%85%A5%E1%86%BC%E1%84%83%E1%85%A9%E1%84%92%E1%85%A7%E1%86%AB%203793062194514294baf029c6c64ce2d5/Simulator_Screen_Shot_-_iPhone_13_-_2022-02-02_at_00.57.04.png)

## 과제 회고 및 리팩토링할 사항

### 회고

- 과제를 하는 동안, 가장 최근에 공부했던 스택을 써보자는 마음으로 DependencyContainer를 사용해보자 라는 마음으로 인했다. 최근에 공부를 하면서, 알고 있었다는 DI 패턴을 실제 혼자 생각하고, 적용을 하려니 굉장히 어려웠다.
- 기존에는 스토리보드를 많이 사용했었다. 이번 과제에서는 스토리보드를 적용하지말고, 코드만 혹은 XIB와 코드만 사용해보자는 생각으로 임했다. 디자인이 없으니 바로바로 코드를 활용해서 UI를 그리기는 조금 어려운 면이 있었다. 따라서 특정부분은 XIB를 활용하면서 UI를 작성했다.
- Rx가 아직 미숙해서, MVVM을 작성하고 데이터 바인딩할 때, didSet 과 클로저를 활용했다. 이번 과제를 통해서 Rx로 했으면, 데이터를 계속 받아오는 동기화작업은 훨씬 더 수월할 수 있겠다는 생각이 들었고 이를 통해서 Rx를 더 열심히공부해야겠다는 생각이 들었다.

### 리팩토링하고 싶은 사항

1. CityName enum을 만들고, 사용을 못했다. Cityname을 사용해서 현재 영어로 되어있는 도시를 한국어로 바꿔야 함
2. 아이콘만 캐싱을 할 것이 아니라, 아이콘 및 데이터 역시 캐싱을 했으면, 데이터를 계속 서버에서 fetching 해오는 일이 적을 수도 있겠다는 생각이 들었다. 

## 프로젝트

