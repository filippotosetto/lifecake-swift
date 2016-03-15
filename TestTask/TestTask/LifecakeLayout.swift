//
//  LifecakeLayout.swift
//  TestTask
//
//  Created by Filippo Tosetto on 14/03/2016.
//  Copyright © 2016 Artjom Popov. All rights reserved.
//

import UIKit

// As picture size is dynamic, let's declare a delegate that will return the height for each photo
protocol LifecakeLayoutDelegate {
  func collectionView(collectionView: UICollectionView, indexPath: NSIndexPath, withWidth: CGFloat) -> CGFloat
}

// Utilty enumaration to get current cell position in our layout
enum Position {
  case Top
  case Left
  case Right
  
  static func getPosition(indexPath: Int) -> Position {
    switch (indexPath) {
    case 1:
      return .Top
    case 2:
      return .Left
    case 3:
      return .Right
    default:
      return .Top
    }
  }
}

class LifecakeLayout: UICollectionViewLayout {
  
  var delegate: LifecakeLayoutDelegate!
  
  var cellPadding: CGFloat = 2.0
  
  // Let's save the layout attributes so we don't have to recalculate them every time
  private var cache = [UICollectionViewLayoutAttributes]()
  
  // Height will be dynamically incemented for every photo added
  private var contentHeight: CGFloat  = 0.0
  // Width is based on screen width minus the insets of the collection view
  private var contentWidth: CGFloat {
    let insets = collectionView!.contentInset
    return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
  }
  
  // Prepare layout for the whole collection view
  // This method is called before the actual layout takes place
  override func prepareLayout() {
    
    if cache.isEmpty {
      
      var yOffset:     CGFloat = 0
      var leftHeight:  CGFloat = 0
      var rightHeight: CGFloat = 0
      
      for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
        
        let indexPath = NSIndexPath(forItem: item, inSection: 0)
        
        // let's get the current cell position
        let position = Position.getPosition((indexPath.row % 3 + 1))
        
        // if the cell is on Top position the column width is the whole screen, otherwise it's width / 2
        let width = contentWidth / CGFloat(position == .Top ? 1 : 2)
        
        // get the photo height from the delegate
        let photoHeight = delegate.collectionView(collectionView!, indexPath: indexPath, withWidth: width)
        
        // Add a bit of padding
        let height = photoHeight + cellPadding
        // if current cell is on the Right position X will be equals to width otherwise start from 0
        let x = position == .Right ? width : 0
        
        let frame = CGRect(x: x , y: yOffset, width: width, height: height)
        // let's add a bit of padding to the frame to make it look nicer
        let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
        
        
        // Recalculate yOffest for the next cell based on current position
        switch position {
        case .Left: // if position Left don't increase the yOffset as next one is Right and has the same yOffset
          leftHeight = height
        case .Right:
          rightHeight = height
          // as images can have different height let's get the max from Left and Rigth to set the yOffset for the next Top image
          yOffset += max(leftHeight, rightHeight)
        case .Top:
          yOffset += height
        }
        
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.frame = insetFrame
        cache.append(attributes)
        
        contentHeight = max(contentHeight, CGRectGetMaxY(frame))
      }
    }
  }
  
  // use this method to invalidate the layour and make it recalculate it
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    // We need to invalidate the cache otherwise nothing happen when the screen rotates
    cache.removeAll()
    return true
  }
  
  // Returns the whole collectionView size
  override func collectionViewContentSize() -> CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  // Returns a collection of layoutAttributes
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
    // Return an array containing any attribute in cache that intersect with the frame provided by the collectionView
    return cache.filter { CGRectIntersectsRect($0.frame, rect) }
  }
}
