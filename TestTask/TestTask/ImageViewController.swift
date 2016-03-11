//
//  ImageViewController.swift
//  TestTask
//
//  Created by Artjom Popov on 11/03/2016.
//  Copyright © 2016 Artjom Popov. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
  
  private var imageName: String!
  private var imageView: ImageView!
  private var imageMeta: ImageMeta!
  
  // MARK: - Initialization
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  required init(imageName: String) {
    super.init(nibName: String(self.dynamicType), bundle: nil)
    self.imageName = imageName
  }
  
  // MARK: - UIView
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
   
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "close")
    
    self.imageView = UINib(nibName: "ImageView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? ImageView
    
    self.loadImage() { image in
      self.imageView?.setupWithImage(image, inView: self.view)
      
      let imageMeta = ImageMeta(name: self.imageName, image: image)
      let label = UILabel(frame: CGRectMake(0, 0, 44, 320))
      label.text = String(format: "Last opened: %@, size: %@", imageMeta.findLastDate(), imageMeta.imageSize())
      label.font = UIFont.systemFontOfSize(10)
      self.navigationItem.titleView = label
    }
  }
  
  // MARK: -
  
  @objc private func close() {
    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  private func loadImage(completion: (image: UIImage) -> Void) {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      let image = UIImage(named: self.imageName)!
      
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        completion(image: image)
      })
    }
  }
}
