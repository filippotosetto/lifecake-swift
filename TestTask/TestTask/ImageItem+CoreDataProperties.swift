//
//  ImageItem+CoreDataProperties.swift
//  TestTask
//
//  Created by Filippo Tosetto on 14/03/2016.
//  Copyright © 2016 Artjom Popov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ImageItem {
  
  @NSManaged public internal(set) var uniqueId: String
  @NSManaged public internal(set) var imageName: String
  @NSManaged public internal(set) var index: NSNumber
  
}
