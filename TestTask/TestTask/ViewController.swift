//
//  ViewController.swift
//  TestTask
//
//  Created by Artjom Popov on 10/03/2016.
//  Copyright © 2016 Artjom Popov. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
  
  @IBOutlet private weak var collectionView: UICollectionView!
  
  var managedObjectContext: NSManagedObjectContext!
  lazy var fetchedResultsController: NSFetchedResultsController = ImageItem.getFetchResultController(self.managedObjectContext, delegate: self)
  
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
    
    self.collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: String(CollectionViewCell))
    
    do {
      try self.fetchedResultsController.performFetch()
    } catch {
      let fetchError = error as NSError
      print("\(fetchError), \(fetchError.userInfo)")
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Listen to changes in managedObject
    NSNotificationCenter.defaultCenter().addObserver(self, selector:"mergeContexts:", name: NSManagedObjectContextDidSaveNotification, object: nil)
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    // Remove Observer
    NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextDidSaveNotification, object: nil)
  }
  
  // Merge different contexts, useful after batch updates in a background managedContext
  func mergeContexts(notification: NSNotification) {
    if notification.object as? NSManagedObjectContext != self.managedObjectContext {
      self.managedObjectContext.performChanges() {
        self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
      }
    }
  }
}

extension ViewController: NSFetchedResultsControllerDelegate {
  // MARK: Fetched Results Controller Delegate Methods
  func controllerDidChangeContent(controller: NSFetchedResultsController) {
    self.collectionView.reloadData()
  }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  // MARK: - UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let sections = fetchedResultsController.sections {
      let sectionInfo = sections[section]
      return sectionInfo.numberOfObjects
    }
    return 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(CollectionViewCell), forIndexPath: indexPath) as! CollectionViewCell
    let data = fetchedResultsController.objectAtIndexPath(indexPath) as! ImageItem
    cell.configureForImage(data.imageName)
    return cell
  }
  
  // MARK: - UICollectionViewDelegate
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let data = fetchedResultsController.objectAtIndexPath(indexPath) as! ImageItem
    let imageController = ImageViewController(imageName: data.imageName)
    self.navigationController?.presentViewController(UINavigationController(rootViewController: imageController), animated: true, completion: nil)
  }
}



