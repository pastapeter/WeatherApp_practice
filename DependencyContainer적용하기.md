## Dependency Containers 

### 적용했던 이유
Dependency Container를 통해서 의존성 역전을 통해 코드를 바꿔 낄 수 있게 만들 수 있다. ViewModel, ViewController, 하위 DependencyContainer에게 의존성을 주입할 때, 주입받는 입장에서는 type을 protocol 형으로 두고, 의존성 주입 시에는 객체를 전달하는 것이다. 이를 통해 필요로 하는 protocol을 채택한 어떤 객체가 와도 상관없다. 이를 통해 test할 코드를 먼저 집어 넣을 수 있다.


### 개요

WeatherApp에는 DependencyContainer는 3개가 존재합니다. `WeatherMainDependency`가 최상위 DependencyContainer이고, 아래로 내려갈수록 하위 DependencyContainer로 볼 수 있습니다. 하위 컨테이너로 넘어가면서, 부모로부터 필요한 의존성을 받을뿐 아니라, 새롭게 필요한 의존성을 만들어서, 만들어야할 객체에 주입합니다.

<img align="center" width="50%" height="50%" src="https://user-images.githubusercontent.com/69891604/152113481-4482caca-2496-4ca0-9d01-53f1688f70cc.png">


### `WeatherMainDependencyContainer`

`WeatherMainViewController`가 보여질 수 있도록 필요한 의존성을 주입해주는 DI Container입니다.  이 컨테이너에서는 아래와 같은 의존성 그래프가 그려진다. 

<img align="center" width="50%" height="50%" src=https://user-images.githubusercontent.com/69891604/152113505-8099fde7-a856-4e6f-9b26-8a51580f9eb4.png>


### `WeatherRepository`

<img align="center" width="50%" height="50%" src=https://user-images.githubusercontent.com/69891604/152113520-9b18e51b-01f5-4060-9e84-5847e90aae50.png>


Repository Pattern을 활용해서 `WeatherRepository` 를 사용하는 특정 객체(`WeatherMainViewModel`)이 데이터가 어디서 오는지 모르면서, 데이터를 fetch할 수 있게 만들었다. 

### `WeatherMainViewController`

<img align="center" width="80%" height="70%" src=https://user-images.githubusercontent.com/69891604/152113578-ccc62474-7327-427d-8f45-afe263ffcb35.png>


`WeatherMainViewController`는 `WeatherMainViewModel`, 이미지를 캐싱할수 있는  `ImageCache`, `WeatherDetailViewController`를 만들 수 있는 Factory Method를 의존성으로 가진다.  그리고 `WeatherMainViewModel`은 현재 날씨를 가져올 수 있는 `CurrentWeatherRepository`를 의존성으로 가진다. 

`WeatherMainViewModel`은 `CurrentWeatherRepository`에서 3초마다 데이터를 가져와서 현재 날씨를 계속 동기화한다. 이러한 동기화된 데이터를 `WeatherMainViewController`에서 아이콘을 보여줄 때, `ImageCache` 구현체를 활용해서 이미지를 캐싱을 사용했고, 그리고 `WeatherMainViewController`에서 `WeatherDetailViewController`로 화면전환이 필요할시, `WeatherDetailViewControllerFactory`를 사용해서 만들고 네이게이션을 활용해서 화면전환을 했다.


### `WeatherDetailDependencyContainer`

<img align="center" width="80%" height="70%" src=https://user-images.githubusercontent.com/69891604/152113636-00c43250-9132-4ff3-94d0-cfb9d7110025.png>


`WeatherMainViewController`에서 `WeatherDetailViewController`로 전환될 때, FactoryMethod로 인해서 `WeatherDetailDependencyContainer`가 생기고, 이를 통해서 `WeatherDetailViewController`와 관련된 모든 의존성 그래프가 그려지면서, 주입된다.

`WeatherDetailViewModel`에서도 역시 5초마다 Repository로부터 데이터를 받아오면서, `WeatherDetailViewController`의 UI를 저절로 변경시킨다. 

그리고 미래 날씨를 누르게 되면, Modal 형태로, `FutureWeatherViewController`를 띄우게 했다.


### `FutureWeatherDependencyContainer`

<img align="center" width="80%" height="70%" src=https://user-images.githubusercontent.com/69891604/152113696-1de663ad-730e-49a4-8384-04e6dd6cee36.png>


`FutureWeatherViewController`에서는 `FutureWeatherViewModel`을 의존, `FutureWeatherViewModel`은 `FutureWeatherRepository`를 의존한다. `FutureWeatherViewModel`에서는 `FutureWeatherViewController`에서 그려줄 꺽은선 그래프를 그리는 데 필요한 정보들을 정제해서 제공한다. 이 데이터는 `FutureWeatherTableViewCell`에 @IBOutlet으로 정의되어있는 lineChart에 바인딩된다. 

`FutureWeatherViewModel`은 다른 ViewModel과는 다르게 매 초마다 데이터를 요구하지않는다. 1분마다 현재 날짜와 미리캐싱한 데이터(viewModel에서 상태를 저장하고 있다.)를 비교한다. 그리고 만약 미리 캐싱한 데이터의 첫 데이터의 날짜 및 시간이, 현재 날짜 및 시간보다 늦을때, 즉 일기예보가 되지 않을떄 다시 데이터를 요청한다.
