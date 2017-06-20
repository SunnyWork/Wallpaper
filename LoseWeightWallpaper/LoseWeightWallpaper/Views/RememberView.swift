//
//  RememberView.swift
//  LoseWeightWallpaper
//
//  Created by Qing Jiao on 13/6/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//


import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RememberView: UIView {
  fileprivate let disposeBag = DisposeBag()
  
  private let callback: (() -> Void)

  init(callback: @escaping (() -> Void)) {
    self.callback = callback
    super.init(frame: CGRect.zero)
    
    backgroundColor = UIColor.black.withAlphaComponent(0.9)
    layer.cornerRadius = 8
    
    var ivWidth: CGFloat = 200
    if frame.size.width < 375 {
      ivWidth = 125
    }
    
    let iv = UIImageView()
    addSubview(iv)
    iv.contentMode = .scaleAspectFit
    iv.image = R.image.despise()
    iv.clipsToBounds = true
    iv.layer.cornerRadius = 20
    iv.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      make.top.equalTo(self).offset(20)
      make.height.width.equalTo(ivWidth)
    }
    
    var fontSize: CGFloat = 25
    if frame.size.width < 375 || UIDevice.current.userInterfaceIdiom == .pad {
      fontSize = 22
    }
    
    let infoLabel = UILabel()
    addSubview(infoLabel)
    infoLabel.text = "Remember why you do this!"
    infoLabel.font = FontType.Medium.font(size: fontSize)
    infoLabel.textColor = .white
    infoLabel.numberOfLines = 0
    infoLabel.textAlignment = .center
    infoLabel.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      make.top.equalTo(iv.snp.bottom).offset(30)
      make.leading.equalTo(self).offset(20)
      make.trailing.equalTo(self).offset(-20)
    }
    
    let okBtn = UIButton()
    addSubview(okBtn)
    okBtn.layer.borderWidth = 1
    okBtn.layer.borderColor = UIColor.white.cgColor
    okBtn.setTitle("Have to quit", for: .normal)
    okBtn.setTitleColor(.white, for: .normal)
    okBtn.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      make.top.equalTo(infoLabel.snp.bottom).offset(20)
      make.width.equalTo(130)
      make.height.equalTo(30)
    }
    
    _ = okBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
      self.hide()
      self.callback()
    })
    
    var btnWidth: CGFloat = 150
    if frame.size.width < 375 {
      btnWidth = 115
    }
    
    let keepBtn = UIButton()
    addSubview(keepBtn)
    keepBtn.layer.cornerRadius = btnWidth / 2
    keepBtn.titleLabel?.numberOfLines = 0
    keepBtn.titleLabel?.contentMode = .center
    keepBtn.titleLabel?.font = FontType.Medium.font(size: 20)
    keepBtn.backgroundColor = DesignColor.Desire
    keepBtn.setTitle("Finish it!", for: .normal)
    keepBtn.setTitleColor(.white, for: .normal)
    keepBtn.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      make.top.equalTo(okBtn.snp.bottom).offset(30)
      make.width.equalTo(btnWidth)
      make.height.equalTo(btnWidth)
      make.bottom.equalTo(self).offset(-15)
    }
    
    _ = keepBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
      self.hide()
      SoundManager.shared.playKeep()
    })
    
    let tapG = UITapGestureRecognizer()
    addGestureRecognizer(tapG)
    tapG.rx.event.subscribe(onNext: { [unowned self] _ in
      self.hide()
    }).addDisposableTo(self.disposeBag)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func show() {
    self.alpha = 0
    UIView.animate(withDuration: 0.4, animations: {
      self.alpha = 1
    })
  }
  
  func hide() {
    UIView.animate(withDuration: 0.3, animations: {
      self.alpha = 0
    }, completion: { _ in
      self.removeFromSuperview()
    })
  }

}
