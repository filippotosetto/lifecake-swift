//
//  CollectionViewCell.swift
//  TestTask
//
//  Created by Artjom Popov on 10/03/2016.
//  Copyright © 2016 Artjom Popov. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
  @IBOutlet private weak var imageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func configureForImage(name: String) {
    self.loadThumbnail(name) { (thumb) -> Void in
      self.imageView.image = thumb
    }
  }
  
  // MARK: -
  
  private func loadThumbnail(name: String, completion: (thumb: UIImage) -> Void) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      let image = UIImage(named: name)!
      let thumbnail = self.thumbnailFromImage(image)
      
      completion(thumb: thumbnail)
    }
  }
  
  private func thumbnailFromImage(image: UIImage) -> UIImage {
    let cgImage = image.CGImage
    
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