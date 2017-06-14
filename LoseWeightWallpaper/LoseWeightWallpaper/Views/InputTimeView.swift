//
//  InputTimeView.swift
//  LoseWeightWallpaper
//
//  Created by Qing Jiao on 11/6/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum InputType {
  case integer
  case string
}

class InputTimeView: UIView {
  private let okCallback: ((String) -> Void)
  private let inputTF = UITextField()
  private let reasonTF = UITextView()
  
  fileprivate let inputType: InputType
  
  init(labelText: String, callback: @escaping ((String) -> Void), inputType: InputType = .integer) {
    okCallback = callback
    self.inputType = inputType
    
    super.init(frame: CGRect.zero)
    
    backgroundColor = UIColor.black.withAlphaComponent(0.9)
    layer.cornerRadius = 8
    
    let infoLabel = UILabel()
    addSubview(infoLabel)
    
    infoLabel.text = labelText
    infoLabel.font = FontType.Medium.font(size: 25)
    infoLabel.textColor = .white
    infoLabel.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      make.top.equalTo(self).offset(20)
    }
    
    if inputType == .string {
      addSubview(reasonTF)
      reasonTF.layer.borderWidth = 1
      reasonTF.textAlignment = .center
      reasonTF.font = FontType.Regular.font(size: 16)
      reasonTF.layer.borderColor = UIColor.white.cgColor
      reasonTF.text = "Because"
      
      reasonTF.snp.makeConstraints { make in
        make.centerX.equalTo(self)
        make.top.equalTo(infoLabel.snp.bottom).offset(15)
        make.width.equalTo(self).offset(-20)
        make.height.equalTo(70)
      }
    } else {
      addSubview(inputTF)
      inputTF.keyboardType = .numberPad
      inputTF.layer.borderWidth = 1
      inputTF.textAlignment = .center
      inputTF.layer.borderColor = UIColor.white.cgColor
      inputTF.textColor = .white
      inputTF.snp.makeConstraints { make in
        make.centerX.equalTo(self)
        make.top.equalTo(infoLabel.snp.bottom).offset(20)
        make.width.equalTo(100)
        make.height.equalTo(30)
      }
    }
    
    let okBtn = UIButton()
    addSubview(okBtn)
    
    okBtn.layer.borderColor = UIColor.white.cgColor
    okBtn.setTitle("OK", for: .normal)
    okBtn.setTitleColor(.white, for: .normal)
    okBtn.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      if inputType == .integer {
        make.top.equalTo(inputTF.snp.bottom).offset(20)
      } else {
        make.top.equalTo(reasonTF.snp.bottom).offset(20)
      }
      make.width.equalTo(50)
      make.height.equalTo(20)
      make.bottom.equalTo(self).offset(-20)
    }
    
    _ = okBtn.rx.tap.subscribe(onNext: { [unowned self] _ in
      self.hide()
      let text: String?
      if self.inputType == .integer {
        text = self.inputTF.text
      } else {
        text = self.reasonTF.text
      }
      if text != nil {
        self.okCallback(text!)
      }
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
