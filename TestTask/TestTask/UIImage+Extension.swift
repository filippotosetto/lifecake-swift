//
//  UIImage+Extension.swift
//  TestTask
//
//  Created by Filippo Tosetto on 11/03/2016.
//  Copyright © 2016 Artjom Popov. All rights reserved.
//

import UIKit
import ImageIO

extension UIImage {
  
  // Using CGImageSource uses much less memory than first allocating a UIImage, transformit to CGImage, and create a new scaled UIImage
  static func getThumbnail(name: String) -> UIImage? {
    
    // Let's create a cache for the thumbnails so we won't create multiple thumbs of the same image
    let cache = ImageCache.sharedCache
    
    // Check if the cache contains the thumb whith a specific name
    guard let thumbnail = cache[name] else {
      
      // in case the thumb is not stored in the cache let's create it...
      let path = NSBundle.mainBundle().pathForResource(name, ofType: "jpg")
      let nsUrl = NSURL(fileURLWithPath: path!)
      if let imageSource = CGImageSourceCreateWithURL(nsUrl, nil) {
        if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
          let width = imageProperties[kCGImagePropertyPixelWidth] as! CGFloat
          let height = imageProperties[kCGImagePropertyPixelHeight] as! CGFloat
          
          let newOptions: [NSString: NSObject] = [
            kCGImageSourceThumbnailMaxPixelSize: max(width, height) / 3.0,
            kCGImageSourceCreateThumbnailFromImageAlways: true
          ]
          let thumbnail = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, newOptions).flatMap { UIImage(CGImage: $0) }
          
          // ....and store it in the cache
          cache[name] = thumbnail
          
          return thumbnail
        }
      }
      return nil
    }
    return thumbnail
  }
}