//
//  AppDelegate.swift
//  TestTask

//  Created by Artjom Popov on 10/03/2016.
//  Copyright © 2016 Artjom Popov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var managedObjectContext: NSManagedObjectContext!
  
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    managedObjectContext = NSManagedObjectContext.setUpSQLiteManagedObjectContext()
    
    seedData()
    
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    let rootVC = ViewController()
    rootVC.managedObjectContext = managedObjectContext
    self.window?.rootViewController = UINavigationController(rootViewController: rootVC)
    self.window?.makeKeyAndVisible()
    
    return true
  }
}

// MARK: Core Data operations
extension AppDelegate {
  
  private func seedData() {
    if ImageItem.countInContext(managedObjectContext) <= 0 {
      let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
      context.persistentStoreCoordinator = managedObjectContext.persistentStoreCoordinator
      context.undoManager = nil;
      context.performChanges() {
        self.loadData(context)
      }
    }
  }
  
  private func loadData(context: NSManagedObjectContext) {
    let itemsCount = 10000
    var set = Set<String>()
    for _ in 0..<itemsCount {
      set.insert(String.randomString(15))
    }
    
    _ = set.enumerate().map { (i, id) -> ImageItem in
      if i % 250 == 0 {
        if !context.saveOrRollback() {
          fatalError("something bad happened while trying to seed database")
        }
      }
      return ImageItem.create(context, uniqueId: id, imageName: "\(i % 4)", index: i)
    }
  }
  
  
  private func cleanDB() {
    let fetchRequest = NSFetchRequest(entityName: "ImageItem")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
      try managedObjectContext.persistentStoreCoordinator!.executeRequest(deleteRequest, withContext: managedObjectContext)
    } catch {
    }
  }
}

