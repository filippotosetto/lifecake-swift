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
      //Convert CharacterView back to String
      string += String(charactersArray[Int(arc4random()) % charactersArray.count])
    }
    
    return string
  }
}