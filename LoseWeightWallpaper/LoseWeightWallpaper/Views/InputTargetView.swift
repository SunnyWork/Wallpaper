//
//  InputTargetView.swift
//  LoseWeightWallpaper
//
//  Created by Qing Jiao on 14/6/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class InputTargetView: UIView {
  private let okCallback: ((Int, Int, String) -> Void)
  private var targetTF: UITextField!
  
  init(callback: @escaping ((Int, Int, String) -> Void)) {
    okCallback = callback
    
    super.init(frame: CGRect.zero)
    
    backgroundColor = UIColor.black.withAlphaComponent(0.9)
    layer.cornerRadius = 8
    
    let infoLabel = UILabel()
    targetTF = createTF()
    
    addSubview(infoLabel)
    addSubview(targetTF)
    
   
    infoLabel.text = "Target Weight(Kg)"
    infoLabel.font = FontType.Medium.font(size: 18)
    infoLabel.textColor = .white
    infoLabel.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      make.top.equalTo(self).offset(20)
    }
    
    targetTF.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      make.top.equalTo(infoLabel.snp.bottom).offset(15)
      make.width.equalTo(140)
      make.height.equalTo(35)
    }
    
    let curLabel = UILabel()
    let curTF = createTF()
    addSubview(curLabel)
    addSubview(curTF)
    
    curLabel.text = "Current (Kg)"
    curLabel.font = FontType.Medium.font(size: 18)
    curLabel.textColor = .white
    curLabel.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      make.top.equalTo(targetTF.snp.bottom).offset(20)
    }
    
    curTF.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      make.top.equalTo(curLabel.snp.bottom).offset(15)
      make.width.equalTo(140)
      make.height.equalTo(35)
    }
    
    let reasonLabel = UILabel()
    let reasonTF = UITextView()
    reasonTF.layer.borderWidth = 1
    reasonTF.textAlignment = .center
    reasonTF.font = FontType.Regular.font(size: 16)
    reasonTF.layer.borderColor = UIColor.white.cgColor
    reasonTF.text = "Because: I don't want to admire others any more!"
    addSubview(reasonLabel)
    addSubview(reasonTF)

    reasonLabel.text = "Why I do this:"
    reasonLabel.font = FontType.Medium.font(size: 18)
    reasonLabel.textColor = .white
    reasonLabel.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      make.top.equalTo(curTF.snp.bottom).offset(20)
    }
    
    reasonTF.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      make.top.equalTo(reasonLabel.snp.bottom).offset(15)
      make.width.equalTo(self).offset(-20)
      make.height.equalTo(60)
    }
    
    let okBtn = UIButton()
    addSubview(okBtn)
    okBtn.layer.borderColor = UIColor.white.cgColor
    okBtn.setTitle("OK", for: .normal)
    okBtn.setTitleColor(.white, for: .normal)
    okBtn.titleLabel?.font = FontType.Regular.font(size: 22)
    okBtn.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      make.top.equalTo(reasonTF.snp.bottom).offset(20)
      make.width.equalTo(50)
      make.height.equalTo(25)
      make.bottom.equalTo(self).offset(-20)
    }
    
    _ = okBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
      self.hide()
      guard let text1 = self.targetTF.text, let targetW = Int(text1) else { return }
      guard let text2 = curTF.text, let currentW = Int(text2) else { return }
      guard let reason = reasonTF.text else {
        reasonTF.text = "I want to see the most beautiful me!"
        return }

      self.okCallback(targetW, currentW, reason)
    })
  }
  
  func show() {
    self.alpha = 0
    UIView.animate(withDuration: 0.3, animations: {
      self.alpha = 1
    }, completion: { _ in
      self.targetTF.becomeFirstResponder()
    })
  }
  
  func hide() {
    self.targetTF.resignFirstResponder()
    UIView.animate(withDuration: 0.3, animations: {
      self.alpha = 0
    }, completion: { _ in
      self.removeFromSuperview()
    })
  }
  
  fileprivate func createTF() -> UITextField {
    let tf = UITextField()
    tf.keyboardType = .numberPad
    tf.layer.borderWidth = 1
    tf.text = ""
    tf.textAlignment = .center
    tf.layer.borderColor = UIColor.white.cgColor
    tf.textColor = .white
    return tf
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
