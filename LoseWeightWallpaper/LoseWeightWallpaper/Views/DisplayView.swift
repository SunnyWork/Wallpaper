//
//  DisplayView.swift
//  LoseWeightWallpaper
//
//  Created by Qing Jiao on 13/6/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import UIKit
import SnapKit

class DisplayView: UIView {
  let imageView = PSY3D_CircleAnimationView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    var wholeArray = Array(1...89)
    wholeArray.shuffle()
    
    var imageArr: [String] = []
    
    for one in 1...40 {
      imageArr.append("image\(wholeArray[one]).jpg")
    }
    
    imageArr.shuffle()
    imageArr.insert("image90.jpg", at: 0)
    imageArr.insert("image76.jpg", at: 0)

    
    imageView.animationDurtion = 5
    imageView.duration = 0.5
    imageView.animationType = PSY3DAnimationTpye.moveIn
    imageView.toLeftSubtype = PSY3DDirectionSubtype.fromRight
    imageView.toRightSubtype = PSY3DDirectionSubtype.fromLeft
    imageView.psy3D_ImageDataSource = imageArr

    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.leading.trailing.top.bottom.equalTo(self)
    }
  }
  
  func closeDisplayTimer() {
    imageView.timer.invalidate()
    imageView.timer = nil
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


