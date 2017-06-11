//
//  InputView.swift
//  LoseWeightWallpaper
//
//  Created by Qing Jiao on 11/6/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class InputView: UIView {
  private let okCallback: ((Int) -> Void)
  private let inputTF = UITextField()
  
  init(labelText: String, callback: @escaping ((Int) -> Void)) {
    okCallback = callback
    
    super.init(frame: CGRect.zero)
    
    backgroundColor = UIColor.black.withAlphaComponent(0.9)
    layer.cornerRadius = 8
    
    let infoLabel = UILabel()
    addSubview(infoLabel)
    addSubview(inputTF)
    let okBtn = UIButton()
    addSubview(okBtn)
    
    infoLabel.text = labelText
    infoLabel.font = FontType.Medium.font(size: 25)
    infoLabel.textColor = .white
    infoLabel.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      make.top.equalTo(self).offset(20)
    }
    
    inputTF.keyboardType = .numberPad
    inputTF.layer.borderWidth = 1
    inputTF.text = "30"
    inputTF.textAlignment = .center
    inputTF.layer.borderColor = UIColor.white.cgColor
    inputTF.textColor = .white
    inputTF.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      make.top.equalTo(infoLabel.snp.bottom).offset(20)
      make.width.equalTo(100)
      make.height.equalTo(30)
    }
    
    okBtn.layer.borderColor = UIColor.white.cgColor
    okBtn.setTitle("OK", for: .normal)
    okBtn.setTitleColor(.white, for: .normal)
    okBtn.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      make.top.equalTo(inputTF.snp.bottom).offset(20)
      make.width.equalTo(50)
      make.height.equalTo(20)
      make.bottom.equalTo(self).offset(-20)
    }
    
    _ = okBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
      self.hide()
      guard let text = self.inputTF.text, let value = Int(text) else { return }
      self.okCallback(value)
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
