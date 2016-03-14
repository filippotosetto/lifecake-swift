//
//  String+Extension.swift
//  TestTask
//
//  Created by Artjom Popov on 10/03/2016.
//  Copyright © 2016 Artjom Popov. All rights reserved.
//

import Foundation

extension String {
  
  static func randomString(length: Int) -> String {
    let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    // need to change to string.characters otherwise the array will have one single elment
    let charactersArray = Array(charactersString.characters)
    
    var string = ""
    for _ in 0..<length {
      // The Int type is a 32-bit integer on the iPhone 5 and a 64-bit integer on the iPhone6.
      // arc4random() returns a UInt32, which has twice the positive range of an Int on a 32 bit device.
      // that means half of the time the number is too big for the cast.
      string += String(charactersArray[Int(arc4random() % UInt32(charactersArray.count))])
    }
    
    return string
  }
}