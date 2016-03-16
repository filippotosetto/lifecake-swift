//
//  ImageItem.swift
//  TestTask
//
//  Created by Filippo Tosetto on 14/03/2016.
//  Copyright © 2016 Artjom Popov. All rights reserved.
//

import Foundation
import CoreData

@objc(ImageItem)
public final class ImageItem: ManagedObject {
  
  class func create(context: NSManagedObjectContext, uniqueId: String, imageName: String, index: Int) -> ImageItem {
    let item: ImageItem = super.create(context)
    item.uniqueId = uniqueId
    item.imageName = imageName
    item.index = index
    return item
  }
  
  class func fetchResultController(context: NSManagedObjectContext, resultControllerDelegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
    let fetchedResultController = ImageItem.getFetchResultController(context, configurationBlock: { (request) -> () in
      let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
      request.sortDescriptors = [sortDescriptor]
    })
    fetchedResultController.delegate = resultControllerDelegate
    return fetchedResultController
  }
}