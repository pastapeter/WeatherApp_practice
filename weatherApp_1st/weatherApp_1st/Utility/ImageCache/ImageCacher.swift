//
//  ImageCacher.swift
//  weatherApp_yagom
//
//  Created by abc on 2022/02/02.
//

import UIKit

final class ImageCacher: ImageCache {
  
  public init(networkRequest: NetworkRequest) {
    self.networkRequest = networkRequest
  }
  
  private var networkRequest: NetworkRequest
  private let cachedImages = NSCache<NSURL, UIImage>()
  private var completionHandlers = [NSURL: [(UIImage) -> Void]]()
  
  private func getImageInCache(url: NSURL) -> UIImage? {
    return cachedImages.object(forKey: url)
  }
  
  func getIcon(with url: String, completion: @escaping (UIImage?) -> Void) {
    let nsUrl = NSURL(string: url)!
    
    //cache에 이미지가 존재할 때
    if let cachedImage = getImageInCache(url: nsUrl) {
      DispatchQueue.main.async {
        completion(cachedImage)
      }
      return
    }
    
    //cache에 이미지가 존재하지 않을때, 서버에서 fetch
    if completionHandlers[nsUrl] != nil {
      //현재 같은 url에 대해서 처리중임
      completionHandlers[nsUrl]?.append(completion)
      return
    } else {
      // 해당 url에 처리가 처음 -> URLSession 필요
      completionHandlers[nsUrl] = [completion]
    }
    
     networkRequest.request(url: url) { [weak self] (result) in
      guard let self = self else { return }
      switch result {
      case .success(let data):
        //이미지 획득
        guard let image = UIImage(data: data), let cacheBlocks = self.completionHandlers[nsUrl] else {
          DispatchQueue.main.async {
            completion(nil)
          }
            return
        }
        
        self.cachedImages.setObject(image, forKey: nsUrl, cost: data.count)
        for cacheBlock in cacheBlocks {
          DispatchQueue.main.async {
            cacheBlock(image)
          }
        }

      case .failure(let error):
        print(error)
        DispatchQueue.main.async {
          completion(nil)
        }
      }
    }
  }
  
}
