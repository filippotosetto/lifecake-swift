//
//  UIImage+Extension.swift
//  TestTask
//
//  Created by Filippo Tosetto on 11/03/2016.
//  Copyright © 2016 Artjom Popov. All rights reserved.
//

import UIKit

extension UIImage {
  func getThumbnail() -> UIImage {
    let cgImage = self.CGImage
    
    let width = CGImageGetWidth(cgImage) / 3
    let height = CGImageGetHeight(cgImage) / 3
    let bitsPerComponent = CGImageGetBitsPerComponent(cgImage)
    let bytesPerRow = CGImageGetBytesPerRow(cgImage)
    let colorSpace = CGImageGetColorSpace(cgImage)
    let bitmapInfo = CGImageGetBitmapInfo(cgImage)
    
    let context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo.rawValue)
    
    CGContextSetInterpolationQuality(context, CGInterpolationQuality.High)
    
    CGContextDrawImage(context, CGRect(origin: CGPointZero, size: CGSize(width: CGFloat(width), height: CGFloat(height))), cgImage)
    return UIImage(CGImage: CGBitmapContextCreateImage(context)!)
  }
}