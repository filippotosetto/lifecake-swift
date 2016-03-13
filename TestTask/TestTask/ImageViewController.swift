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
    self.imageName = "\(imageName).jpg"
  }
  
  // MARK: - UIView
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "close")
    
    self.imageView = UINib(nibName: "ImageView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? ImageView
    self.navigationController?.hidesBarsWhenVerticallyCompact = true
    self.navigationController?.hidesBarsOnTap = true
    
    self.loadImage() { image in
      guard let image = image else {
        return
      }
      self.imageView?.setupWithImage(image, inView: self.view)
      // Set Image View Constraint
      self.setConstraints()
      self.imageMeta = ImageMeta(name: self.imageName, image: image)
      let label = UILabel(frame: CGRectMake(0, 0, 44, 320))
      label.text = String(format: "Last opened: %@, size: %@", self.imageMeta.findLastDate(), self.imageMeta.imageSize())
      label.font = UIFont.systemFontOfSize(10)
      self.navigationItem.titleView = label
    }
  }
  
  deinit {
    print("ImageVC deinit")
  }
  
  // MARK: -
  
  @objc private func close() {
    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  private func loadImage(completion: (image: UIImage?) -> Void) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      let name = self.imageName.stringByReplacingOccurrencesOfString(".jpg", withString: "")
      let image = UIImage.getThumbnail(name)
      dispatch_async(dispatch_get_main_queue()) { () -> Void in
        completion(image:  image)
      }
    }
  }
}

// MARK: Autolayout
extension ImageViewController {
  // Refresh constraint when device rotates
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    view.setNeedsUpdateConstraints()
  }
  
  private func setConstraints() {
    self.imageView.translatesAutoresizingMaskIntoConstraints = false
    
    let leadingConstrint = NSLayoutConstraint(
      item: imageView,
      attribute: .Leading,
      relatedBy: .LessThanOrEqual,
      toItem: view,
      attribute: .LeadingMargin,
      multiplier: 1.0,
      constant: 0.0
    )
    let trailingConstrint = NSLayoutConstraint(
      item: imageView,
      attribute: .Trailing,
      relatedBy: .LessThanOrEqual,
      toItem: view,
      attribute: .TrailingMargin,
      multiplier: 1.0,
      constant: 0.0
    )
    let verticalConstraint = NSLayoutConstraint(
      item: imageView,
      attribute: .CenterY,
      relatedBy: .Equal,
      toItem: view,
      attribute: .CenterY,
      multiplier: 1.0,
      constant: 0.0
    )
    let horizontalConstraint = NSLayoutConstraint(
      item: imageView,
      attribute: .CenterX,
      relatedBy: .Equal,
      toItem: view,
      attribute: .CenterX,
      multiplier: 1.0,
      constant: 0.0
    )
    let aspectRatioConstrint = NSLayoutConstraint(
      item: imageView,
      attribute: .Width,
      relatedBy: .Equal,
      toItem: imageView,
      attribute: .Height,
      multiplier: 1.0,
      constant: 0.0
    )
    let topConstraint = NSLayoutConstraint(
      item: imageView,
      attribute: .Top,
      relatedBy: .GreaterThanOrEqual,
      toItem: view,
      attribute: .TopMargin,
      multiplier: 1.0,
      constant: 0
    )
    let bottomConstraint = NSLayoutConstraint(
      item: imageView,
      attribute: .Bottom,
      relatedBy: .GreaterThanOrEqual,
      toItem: view,
      attribute: .BottomMargin,
      multiplier: 1.0,
      constant: 0
    )
    
    verticalConstraint.priority = 1000
    bottomConstraint.priority = 900
    topConstraint.priority = 900
    
    NSLayoutConstraint.activateConstraints([
      leadingConstrint,
      trailingConstrint,
      verticalConstraint,
      horizontalConstraint,
      aspectRatioConstrint,
      topConstraint,
      bottomConstraint
      ])
  }
}