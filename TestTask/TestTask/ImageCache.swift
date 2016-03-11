//
//  ImageCache.swift
//  TestTask
//
//  Created by Filippo Tosetto on 11/03/2016.
//  Copyright © 2016 Artjom Popov. All rights reserved.
//

import UIKit

class ImageCache {
  
  // Let's use NSCache as it's thread safe and also purges itself if the OS is reclaiming memory
  // It is slightly slowr than Dictionarie tho
  static let sharedCache: NSCache = {
    let cache = NSCache()
    cache.name = "ImageCache"
    return cache
  }()
}

extension NSCache {
  subscript(key: String) -> UIImage? {
    get {
      return objectForKey(key) as? UIImage
    }
    set {
      // check if the object is already there
      guard let _ =  objectForKey(key) else {
        if let value: UIImage = newValue {
          setObject(value, forKey: key)
        } else {
          removeObjectForKey(key)
        }
        return
      }
    }
  }
}