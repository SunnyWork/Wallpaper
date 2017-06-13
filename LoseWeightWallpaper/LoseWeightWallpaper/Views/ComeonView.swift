//
//  ComeonView.swift
//  LoseWeightWallpaper
//
//  Created by Qing Jiao on 12/6/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum ComeonType {
  case finishSomeTime
  case finishAll
}

class ComeonView: UIView {
  fileprivate var timer: Timer?
  fileprivate let disposeBag = DisposeBag()
  fileprivate let type: ComeonType
  
  init(text: String, type: ComeonType = .finishSomeTime) {
    self.type = type
    super.init(frame: CGRect.zero)
    
    backgroundColor = UIColor.black.withAlphaComponent(0.9)
    layer.cornerRadius = 8
    
    let iv = UIImageView()
    addSubview(iv)
    iv.contentMode = .scaleAspectFit
    
    if type == .finishSomeTime {
      iv.image = R.image.boy_do()
      iv.snp.makeConstraints { make in
        make.centerX.equalTo(self)
        make.top.equalTo(self).offset(100)
        make.height.width.equalTo(180)
      }
    } else {
      iv.image = R.image.wonder_women()
      iv.snp.makeConstraints { make in
        make.centerX.equalTo(self)
        make.top.equalTo(self).offset(100)
        make.height.width.equalTo(250)
      }
    }
    
    let infoLabel = UILabel()
    addSubview(infoLabel)
    
    infoLabel.text = text
    infoLabel.font = FontType.Medium.font(size: 25)
    infoLabel.textColor = .white
    infoLabel.numberOfLines = 0
    infoLabel.textAlignment = .center
    infoLabel.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      make.top.equalTo(iv.snp.bottom).offset(30)
      make.leading.equalTo(self).offset(20)
      make.trailing.equalTo(self).offset(-20)
    }
    
    let tapG = UITapGestureRecognizer()
    addGestureRecognizer(tapG)
    tapG.rx.event.subscribe(onNext: { [unowned self] _ in
      self.hide()
    }).addDisposableTo(self.disposeBag)
  }
  
  func show() {
    self.alpha = 0
    let duration = (type == .finishSomeTime) ? 4 : 10
    UIView.animate(withDuration: 0.3, animations: {
      self.alpha = 1
    }, completion: { _ in
      self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(duration), target: self, selector: #selector(self.hide), userInfo: nil, repeats: false)
    })
  }
  
  func hide() {
    self.timer?.invalidate()
    self.timer = nil
    
    UIView.animate(withDuration: 0.3, animations: {
      self.alpha = 0
    }, completion: { _ in
      self.removeFromSuperview()
    })
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
