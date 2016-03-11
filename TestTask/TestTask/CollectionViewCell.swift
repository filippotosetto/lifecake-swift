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
    
    // Let's create a cache for the thumbnails so we won't create multiple thumbs of the same image
    let cache = ImageCache.sharedCache
    
    // Check if the cache contains the thumb whith a specific name
    guard let thumbnail = cache[name] else {
      
      // in case the thumb is not stored in the cache let's create it...
      self.loadThumbnail(name) { (thumb) -> Void in
        self.imageView.image = thumb
        // and store it in the cache
        cache[name] = thumb
      }
      return
    }
    self.imageView.image = thumbnail
  }
  
  // MARK: -
  
  private func loadThumbnail(name: String, completion: (thumb: UIImage) -> Void) {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      let image = UIImage(named: name)!
      let thumbnail = image.getThumbnail()
      // need to notify the main thread to update the UI
      dispatch_async(dispatch_get_main_queue()) { () -> Void in
        completion(thumb: thumbnail)
      }
    }
  }
  
  
  // This method has been moved to UIImage+Extension as it could be reused in the future
  //  private func thumbnailFromImage(image: UIImage) -> UIImage {
}
