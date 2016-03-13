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
  //  
  //  func getThumbnail() -> UIImage? {
  //    let cgImage = self.CGImage
  //    
  //    let width = CGImageGetWidth(cgImage) / 3
  //    let height = CGImageGetHeight(cgImage) / 3
  //    let bitsPerComponent = CGImageGetBitsPerComponent(cgImage)
  //    let bytesPerRow = CGImageGetBytesPerRow(cgImage)
  //    let colorSpace = CGImageGetColorSpace(cgImage)
  //    let bitmapInfo = CGImageGetBitmapInfo(cgImage)
  //    
  //    let context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo.rawValue)
  //    
  //    CGContextSetInterpolationQuality(context, CGInterpolationQuality.High)
  //    
  //    CGContextDrawImage(context, CGRect(origin: CGPointZero, size: CGSize(width: CGFloat(width), height: CGFloat(height))), cgImage)
  //    
  //    let scaledImage = CGBitmapContextCreateImage(context).flatMap { UIImage(CGImage: $0) }
  //    
  //    return scaledImage
  //  }
  
  
  // Using CGImageSource uses much less memory than first allocating a UIImage, transformit to CGImage, and create a new scaled UIImage
  static func getThumbnail(name: String) -> UIImage? {
    
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
        let thumbnail = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, newOptions)
        return thumbnail.flatMap { UIImage(CGImage: $0) }
      }
    }
    return nil
  }
}