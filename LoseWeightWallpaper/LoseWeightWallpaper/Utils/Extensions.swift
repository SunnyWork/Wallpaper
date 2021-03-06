//
//  Extensions.swift
//  LoseWeightWallpaper
//
//  Created by Qing Jiao on 9/6/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  convenience init(hex6: Int) {
    self.init(
      red: (hex6 >> 16) & 0xFF,
      green: (hex6 >> 8) & 0xFF,
      blue: hex6 & 0xFF
    )
  }
}


extension Array {
  mutating func shuffle() {
    if count < 2 { return }
    for i in 0..<(count - 1) {
      let j = Int(arc4random_uniform(UInt32(count - i))) + i
      let tmp = self[i]
      self[i] = self[j]
      self[j] = tmp
    }
  }
}
