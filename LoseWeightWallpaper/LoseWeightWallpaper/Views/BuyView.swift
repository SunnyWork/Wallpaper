//
//  BuyView.swift
//  LoseWeightWallpaper
//
//  Created by Qing Jiao on 18/6/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class BuyView: UIView {
  private let okCallback: (() -> Void)
  private let inputTF = UITextField()
  private let reasonTF = UITextView()
    
  init(labelText: String, amount: String?, callback: @escaping (() -> Void)) {
    okCallback = callback
    
    super.init(frame: CGRect.zero)
    
    backgroundColor = UIColor.black.withAlphaComponent(0.9)
    layer.cornerRadius = 8
    
    let infoLabel = UILabel()
    addSubview(infoLabel)
    infoLabel.numberOfLines = 0
    infoLabel.contentMode = .center
    infoLabel.text = labelText
    infoLabel.font = FontType.Medium.font(size: 18)
    infoLabel.textColor = .white
    infoLabel.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      make.top.equalTo(self).offset(40)
      make.leading.equalTo(self).offset(17)
      make.trailing.equalTo(self).offset(-17)
    }
    
    let moneyLabel = UILabel()
    addSubview(moneyLabel)
    moneyLabel.text = amount
    moneyLabel.font = FontType.Regular.font(size: 18)
    moneyLabel.textColor = .white
    moneyLabel.snp.makeConstraints { make in
      make.centerX.equalTo(self).offset(-30)
      make.top.equalTo(infoLabel.snp.bottom).offset(20)
    }
    
    let okBtn = UIButton()
    addSubview(okBtn)
    
    okBtn.layer.borderColor = UIColor.white.cgColor
    okBtn.setTitle("Ok", for: .normal)
    okBtn.titleLabel?.font = FontType.Regular.font(size: 18)
    okBtn.setTitleColor(.white, for: .normal)
    okBtn.snp.makeConstraints { make in
      make.centerX.equalTo(self).offset(30)
      make.centerY.equalTo(moneyLabel)
      make.width.equalTo(30)
      make.bottom.equalTo(self).offset(-50)
    }
    
    _ = okBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
      self.hide()
      self.okCallback()
     })
  }
  
  func show() {
    self.alpha = 0
    UIView.animate(withDuration: 0.3, animations: {
      self.alpha = 1
    }, completion: { _ in
      self.inputTF.becomeFirstResponder()
    })
  }
  
  func hide() {
    self.inputTF.resignFirstResponder()
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
