//
//  ViewModelBindableType.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/02/25.
//

/*
 ViewModelBindableType
 VC에서 채택을 할 경우, bind 함수를 사용할 수 있다.
 associdatedType을 사용해서 ViewModelType은 동적으로 변하게 되어있다.
 따라서 동적으로 각 Viewmodel 마다 binding 이 가능 
 
 */

import UIKit

protocol ViewModelBindableType {
  associatedtype ViewModelType
  
  var viewModel: ViewModelType {get set}
  func bindViewModel()
}

extension ViewModelBindableType where Self: UIViewController {
  mutating func bind(viewModel: Self.ViewModelType) {
    self.viewModel = viewModel
    loadViewIfNeeded()
    
    bindViewModel()
  }
}

