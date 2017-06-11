//
//  Driver-Font.swift
//  Driver
//
//  Created by 宋清晨 on 16/3/3.
//  Copyright © 2016年 陈扬. All rights reserved.
//
import UIKit

enum FontType {
  
  case Regular
  case RegularItalic
  case Light
  case LightItalic
  case Medium
  case MediumItalic
  case Bold
  case BoldItalic
  case XBold
  case XBoldItalic
  
  func font(size: CGFloat) -> UIFont {
    let font: UIFont!
    switch self {
    case .Regular:
      font = R.font.sanomatGrabAppRegular(size: size)
    case .RegularItalic:
      font = R.font.sanomatGrabAppRegularItalic(size: size)
    case .Light:
      font = R.font.sanomatGrabAppLight(size: size)
    case .LightItalic:
      font = R.font.sanomatGrabAppLightItalic(size: size)
    case .Medium:
      font = R.font.sanomatGrabAppMedium(size: size)
    case .MediumItalic:
      font = R.font.sanomatGrabAppMediumItalic(size: size)
    case .Bold:
      font = R.font.sanomatGrabAppBold(size: size)
    case .BoldItalic:
      font = R.font.sanomatGrabAppBoldItalic(size: size)
    case .XBold:
      font = R.font.sanomatGrabAppXBold(size: size)
    case .XBoldItalic:
      font = R.font.sanomatGrabAppXBoldItalic(size: size)
    }
    return font
  }
}
