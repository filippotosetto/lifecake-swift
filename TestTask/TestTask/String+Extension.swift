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
    let charactersArray = Array(arrayLiteral: charactersString)
    
    var string = ""
    for _ in 0..<length {
      string += charactersArray[Int(arc4random()) % charactersArray.count]
    }
    
    return string
  }
}