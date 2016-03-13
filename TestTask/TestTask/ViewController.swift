//
//  ViewController.swift
//  TestTask
//
//  Created by Artjom Popov on 10/03/2016.
//  Copyright © 2016 Artjom Popov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet private weak var collectionView: UICollectionView!
  
  private var dataSource = [(id: String, imageName: String)]()
  private var uniqueKeys = [String]()
  private let itemsCount = 10000
  
  // MARK: - Initialization
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  required init() {
    super.init(nibName: String(self.dynamicType), bundle: nil)
  }
  
  // MARK: - UIView
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.loadData()
    self.collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: String(CollectionViewCell))
    
  }
  
  // MARK: -
  
  private func loadData() {
    let startTime = CACurrentMediaTime()
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      
      
      //      This operation takes a looooong time, probably better to put it on a background thread so it doesn't block the UI
      //      for i in 0..<self.itemsCount {
      //        let id = String.randomString(15)
      //        if !self.uniqueKeys.contains(id) {
      //          self.uniqueKeys.append(id)
      //          self.dataSource.append((id: id, imageName: "\(i % 4).jpg"))
      //        }
      //      }
      
      
      // First let's map the randomStrings to a set so there's no need to check if the collection contains the element
      var set = Set<String>()
      for _ in 0..<self.itemsCount {
        set.insert(String.randomString(15))
      }
      
      // Than map the set to uniqueKeys
      self.uniqueKeys = Array(set)
      
      // and finally populate the dataSource array with the tuple (id, imageName)
      self.dataSource = set.enumerate().map { (i, id) in
        //        return (id: id, imageName: "\(i % 4).jpg")
        return (id: id, imageName: "\(i % 4)")
        
      }
      
      dispatch_async(dispatch_get_main_queue()) { () -> Void in
        // let's reload the collection view data otherwise nothing will be displayed
        self.collectionView.reloadData()
        
        let totalTimeSpend = Double(CACurrentMediaTime() - startTime)
        print("total time spend:", totalTimeSpend)
        
        // With Array it runs in 15.4702635139984
        // With Set   it runs in 0.322475198991015
      }
    }
    
  }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  // MARK: - UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.dataSource.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(CollectionViewCell), forIndexPath: indexPath) as! CollectionViewCell
    let data = self.dataSource[indexPath.row]
    cell.configureForImage(data.imageName)
    
    return cell
  }
  
  // MARK: - UICollectionViewDelegate
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let data = self.dataSource[indexPath.row]
    let imageController = ImageViewController(imageName: data.imageName)
    self.navigationController?.presentViewController(UINavigationController(rootViewController: imageController), animated: true, completion: nil)
  }
}



