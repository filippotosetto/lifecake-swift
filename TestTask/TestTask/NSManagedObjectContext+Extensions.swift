//
//  NSManagedObjectContext+Extensions.swift
//  TestTask
//
//  Created by Filippo Tosetto on 14/03/2016.
//  Copyright © 2016 Artjom Popov. All rights reserved.
//

import CoreData



extension NSManagedObjectContext {
  public func insertObject<A: ManagedObject where A: ManagedObjectType>() -> A {
    guard let obj = NSEntityDescription.insertNewObjectForEntityForName(A.entityName, inManagedObjectContext: self) as? A else {
      fatalError("Wrong object type")
    }
    return obj
  }
  
  public func entityForName(name: String) -> NSEntityDescription {
    guard let psc = persistentStoreCoordinator else {
      fatalError("PSC missing")
    }
    guard let entity = psc.managedObjectModel.entitiesByName[name] else {
      fatalError("Entity \(name) not found")
    }
    return entity
  }
  
  
  public func saveOrRollback() -> Bool {
    do {
      try save()
      return true
    } catch {
      rollback()
      return false
    }
  }
  
  public func performSaveOrRollback() {
    performBlock {
      self.saveOrRollback()
    }
  }
  
  public func performChanges(block: () -> ()) {
    performBlock {
      block()
      self.saveOrRollback()
    }
  }
  
}




extension NSManagedObjectContext {
  
  static func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
    let managedObjectModel = NSManagedObjectModel.mergedModelFromBundles([NSBundle.mainBundle()])!
    
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    
    do {
      try persistentStoreCoordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
    } catch {
      print("Adding in-memory persistent store coordinator failed")
    }
    
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    
    return managedObjectContext
  }
  
  
  static func setUpSQLiteManagedObjectContext() -> NSManagedObjectContext {
    let modelURL = NSBundle.mainBundle().URLForResource("TestTask", withExtension: "momd")!
    
    let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)!
    
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    let url = NSURL.documentsURL.URLByAppendingPathComponent("TestTask.sqlite")
    
    do {
      try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
    } catch {
      print("Adding in-memory persistent store coordinator failed")
    }
    
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    
    return managedObjectContext
  }
  
}

extension NSURL {
  
  static func temporaryURL() -> NSURL {
    return try! NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true).URLByAppendingPathComponent(NSUUID().UUIDString)
  }
  
  static var documentsURL: NSURL {
    return try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
  }
}

