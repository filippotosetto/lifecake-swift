//
//  CollectionViewCell.swift
//  TestTask
//
//  Created by Artjom Popov on 10/03/2016.
//  Copyright © 2016 Artjom Popov. All rights reserved.
//

import UIKit

let serialQueue = dispatch_queue_create("com.TestTask.ThumbQueue", nil)

class CollectionViewCell: UICollectionViewCell {
  
  @IBOutlet private weak var imageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func configureForImage(name: String) {
    // Better to dispatch the operation pn a serial queue, in this way we still perform everything on a background thread and don't block the main one
    // But in the same time we don't alloc too much memory during the image resizing operation
    dispatch_async(serialQueue) {
      // Let's create a cache for the thumbnails so we won't create multiple thumbs of the same image
      let cache = ImageCache.sharedCache
      
      // Check if the cache contains the thumb whith a specific name
      guard let thumbnail = cache[name] else {
        
        // in case the thumb is not stored in the cache let's create it...
        self.loadThumbnail(name) { (thumb) -> Void in
          guard let thumb = thumb else {
            return
          }
          self.setThumb(thumb)
          // and store it in the cache
          cache[name] = thumb
        }
        return
      }
      self.setThumb(thumbnail)
    }
  }
  
  // MARK: -
  
  private func loadThumbnail(name: String, completion: (thumb: UIImage?) -> Void) {
    completion(thumb: UIImage.getThumbnail(name))
  }
  
  private func setThumb(image: UIImage) {
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
      self.imageView.image = image
    }
  }
}
