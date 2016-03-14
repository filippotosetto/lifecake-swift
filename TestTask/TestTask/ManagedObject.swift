//
//  ManagedObject.swift
//  TestTask
//
//  Created by Filippo Tosetto on 14/03/2016.
//  Copyright © 2016 Artjom Popov. All rights reserved.
//


import CoreData

public class ManagedObject: NSManagedObject, ManagedObjectType {
}

public protocol ManagedObjectType: class {
  static var entityName: String { get }
  var managedObjectContext: NSManagedObjectContext? { get }
}

extension ManagedObjectType where Self: ManagedObject {
  
  public static func create<A: ManagedObject>(context: NSManagedObjectContext) -> A {
    let entity: A = context.insertObject()
    return entity
  }
  
  public static var entityName: String {
    return String(self)
  }
  
  public static func fetchInContext<A: ManagedObject>(context: NSManagedObjectContext, @noescape configurationBlock: NSFetchRequest -> () = { _ in }) -> [A] {
    let request = NSFetchRequest(entityName: Self.entityName)
    configurationBlock(request)
    guard let result = try! context.executeFetchRequest(request) as? [A] else {
      fatalError("Fetched objects have wrong type")
    }
    return result
  }
  
  public static func getFetchResultController(context: NSManagedObjectContext, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
    let request = NSFetchRequest(entityName: Self.entityName)
    
    let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
    request.sortDescriptors = [sortDescriptor]
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchedResultsController.delegate = delegate
    
    return fetchedResultsController
  }
  
  
  public static func countInContext(context: NSManagedObjectContext, @noescape configurationBlock: NSFetchRequest -> () = { _ in }) -> Int {
    let request = NSFetchRequest(entityName: entityName)
    configurationBlock(request)
    var error: NSError?
    let result = context.countForFetchRequest(request, error: &error)
    guard result != NSNotFound else { fatalError("Failed to execute fetch request: \(error)") }
    return result
  }
}
