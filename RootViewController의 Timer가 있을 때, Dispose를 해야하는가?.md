# RootViewController와 Timer

## 문제점

RootViewController에서 Timer를 통해서 API를 활용해서 데이터를 가져올때, 다음 ViewController를 push를 한다고 할때, RootViewController에서 돌아가는 Timer를 dispose 해야하나?

## Rxswift 전

`Timer` 를 활용해서 ViewModel이 생성될 때, `Timer`를 돌리고, `pushViewController`를 하면 `Timer.invalidate()`를 활용하였다. 

`popViewController` 이후에는 `viewWillAppear`에서 `Timer`가 `invalidate`한지 확인한 뒤에,  `Timer`를 다시 키면서 다시 API Call를 하는 과정이 있었다

## Rxswift 이후

### 1. Timer는 Dispose되어야 멈춘다는 생각

Rxswift에서 .timer, .interval 과 같은 연산자들은 모두 dispose가 되어야지만 메모리에서 내려오게 되어있다. 그래서 `rootViewController`에서 다른 ViewController로 push 되었을때, Timer가 계속 돌아가게 만들 수 없으니 dispose를 해야한다고 생각했다.

### 2. 어디서 Dispose를 하는가?

그렇다면 어디서 Dispose를 해야하는가에 대해서 생각을 했다. `rootViewController`인  `WeatherMainViewController`을 만들 때, `WeatherMainViewModel`도 의존성으로 들어가기 때문에, ViewModel로 당연히 살아있을테니, `deinit`이 안될 것이 분명했다.

- **`WeatherDetailViewController` 로 push되기전에 dispose**

```swift
//WeatherMainViewController.swift

tableView.rx.modelSelected(WeatherMainCellModel.self)
      .subscribe(onNext: { [weak self] in
        guard let self = self else {return}
        self.viewModel.select(item: $0)
        let vc = self.makeWeatherDetailVCFactory
          .makeWeatherDetailViewController(selectedCity: self.viewModel.selectedCity)
        self.navigationController?
          .pushViewController(vc,
                              animated: true)
      })
      .disposed(by: disposeBag)
```

```swift
//WeatherMainViewModel.swift

func select(item:WeatherMainCellModel) {
    disposeBag = DisposeBag()
    self.selectedCity = item.name
  }
```

- **`WeatherMainViewController`의 `ViewwillDisappear`에서 dispose**

### 3. `WeatherMainViewController`에서 `WeatherMainViewModel`의 Timer를 pop해서 다시 들어왔을때, 다시 구독을 해야하는가?

문제점은 다시 pop 했을 때, ViewModel에서 bind를 하기 위해서 Viewmodel의 Driver를 다시 구독해야한다는 것이었다. 이말은 결국 Dispose된 타이머를 다시 구독해야한다는 의미였다.

근데 이미 현재 init 에서 `self.bind(viewModel: self.viewModel)`를 부르는 상황이었다.

```swift
//WeatherMainViewController.swift

func bindViewModel() {
      
    viewModel.weatherInfo
      .drive(tableView.rx.items(cellIdentifier: WeatherMainTableViewCell.identifier, cellType: WeatherMainTableViewCell.self)) { [weak self] (index, element, cell) in
        cell.bind(cellModel: element)
        self?.imageCache.getIcon(with: element.imageUrl, completion: { (image) in
          if let image = image {
            cell.weatherImageView.image = image
          }
        })
      }
      .disposed(by: disposeBag)
    
    tableView.rx.modelSelected(WeatherMainCellModel.self)
      .subscribe(onNext: { [weak self] in
        guard let self = self else {return}
        self.viewModel.select(item: $0)
        let vc = self.makeWeatherDetailVCFactory
          .makeWeatherDetailViewController(selectedCity: self.viewModel.selectedCity)
        self.navigationController?
          .pushViewController(vc,
                              animated: true)
      })
      .disposed(by: disposeBag)
    
  }

public init(viewModel: WeatherMainViewModel, weatherDetailViewControllerFactory: WeatherDetailViewControllerFactory, imageCache: ImageCache) {
    self.viewModel = viewModel
    self.makeWeatherDetailVCFactory = weatherDetailViewControllerFactory
    self.imageCache = imageCache
    super.init(nibName: nil, bundle: nil)
    self.bind(viewModel: self.viewModel)
  }
```

애초에 rootViewController이고, 현재상황에서 init이 다시 불릴 상황은 없다고 판단했다. 그래서 `self.bind(viewModel: self.viewModel)` 의 위치를 옮겨 볼 생각을 했다.

### 4. 다시 구독한다면 무슨일이 생기는가

`ViewWillAppear`에서 `self.bind(viewModel: self.viewModel)` 를 호출하면서 구독을 시작했을때, 처음 `rootViewController`로 입장할 때는 문제가 없다. 

- **Push 할 때의 문제**

ViewModel의 Timer와 ViewController의 구독을 모두 dispose 하고 다음 화면으로 push할 경우, 넘어가는 animation에 빈화면이 보이게 되었다.

- **Dispose를 하지 않고 구독을 했을때의 오류 발생**

또한 Dispose를 하지않고 Push를 했다가 다시 pop 할 경우, 다시 `viewWillAppear` 함수가 불리고, 재구독이 시작할때 오류를 발생시킨다. dispose를 시키지 않았고, 아까 그 객체 그대로인데, 함수 그대로 다시 불리기 때문이다. 

- **Dispose하고 ViewWillAppear에서  재구독을 했을 때의 성능 저하 발생**

`ViewWillAppear`에서 함수에서 다시 구독을 할 경우, animation 이후에 Timer가 발생하기에, 첫화면이 일반 배경이었다가, 구독이 시작되면서 Tableview가 그 다음 그려지게 된다. rxswift를 사용해서 tableView에 바인드하는 것 자체에서 tableview를 그리는 것이 실행되기에 `viewWillAppear`에서 사용될 경우, 성능 저하를 확인했다. (이 이유가 맞는 말인지는 잘 모르겠다.)

### 5. 해결방법

1. 현재 앱에서 `rootViewController`는 다른 ViewController와 교체될 일이 없기 때문에, 항상 메모리에 남아 있어야 한다. 즉, dispose를 시키지 않고 유지한다.
2. `WeatherMainViewController`의 timer Observable은 메모리에 남아있어야한다. 즉, `rootViewController`에 한해서 `Timer`는 일시 중지할 수 있다. `running`이라는 Relay를 통해 `true`, `false`를 넣어주면서, `Timer`를 방출 아니면 `empty`를 방출할 수 있다.

```swift
//WeatherMainViewModel.swift

private var running: BehaviorRelay = BehaviorRelay(value: true)

let isRunning = running.asObservable()
      .debug("타이머 굴러가는중")
      .flatMapLatest { isRunning in
        isRunning ? Observable<Int>
        .timer(.seconds(0), period: .seconds(5), scheduler: MainScheduler.instance) : .empty() }

func viewWillAppear() {
    running.accept(true)
  }

func select(item:WeatherMainCellModel) {
    self.running.accept(false)
    self.selectedCity = item.name
  }
```

1. 일시 중지, 다시 시작에 대한 메서드를 viewWillAppear에서 나타낸다.

```swift
//WeatherMainViewController.swift

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.viewWillAppear()
  }
```