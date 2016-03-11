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
    self.collectionView.reloadData()
  }

  // MARK: -
  
  private func loadData() {
    let startTime = CACurrentMediaTime()
    
    for i in 0..<self.itemsCount {
      let id = String.randomString(15)
      if !self.uniqueKeys.contains(id) {
        self.uniqueKeys.append(id)
        self.dataSource.append((id: id, imageName: "\(i % 4).jpg"))
      }
    }
    
    let totalTimeSpend = Double(CACurrentMediaTime() - startTime)
    print("total time spend:", totalTimeSpend)
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



