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
  let imageArr = ["people_1.jpg", "people_2.jpg", "people_3.jpg", "word_1.jpg"]
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let imageView = PSY3D_CircleAnimationView()
    imageView.animationDurtion = 5
    imageView.duration = 0.5
    imageView.animationType = PSY3DAnimationTpye.moveIn
    imageView.toLeftSubtype = PSY3DDirectionSubtype.fromLeft
    imageView.toRightSubtype = PSY3DDirectionSubtype.fromLeft
    imageView.psy3D_ImageDataSource = imageArr

    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.leading.trailing.top.bottom.equalTo(self)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

