//
//  MenuWindow.swift
//  ColourMemory
//
//  Created by jiao qing on 27/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MenuWindow: UIWindow {
  fileprivate let disposeBag = DisposeBag()
  var setTargetCallback: (() -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    //backgroundColor = UIColor.white.withAlphaComponent(0.5)
    
    let tapG = UITapGestureRecognizer()
    addGestureRecognizer(tapG)
    tapG.rx.event.subscribe(onNext: { [unowned self] _ in
      self.hideAnimation(nil)
    }).addDisposableTo(self.disposeBag)
    
    
    let sideView = UIView()
    sideView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    addSubview(sideView)
    sideView.snp.makeConstraints { make in
      make.width.equalTo(220)
      make.leading.top.height.equalTo(self)
    }
    
    let targetBtn = UIButton()
    sideView.addSubview(targetBtn)
    targetBtn.titleLabel?.textColor = UIColor.white
    targetBtn.setTitle("Reset Target", for: .normal)
    targetBtn.snp.makeConstraints { make in
      make.leading.equalTo(17)
      make.top.equalTo(64)
      make.centerX.equalTo(sideView)
    }
    _ = targetBtn.rx.tap.subscribe(onNext: { [unowned self] obj in
      self.hideAnimation() { _ in
        self.setTargetCallback?()
      }
    })
  }
  
  func showAnimation(_ completion: ((Bool) -> Void)?){
    self.frame = CGRect(x: -bounds.size.width, y: 0, width: bounds.size.width, height: bounds.size.height)
    self.windowLevel = UIWindowLevelNormal + 1
    UIView.animate(withDuration: 0.3, animations: {
      self.frame = UIScreen.main.bounds
    }, completion: {(f : Bool) -> Void in
      if completion != nil {
        completion!(f)
      }
    })
  }
  
  func hideAnimation(_ completion: ((Bool) -> Void)?){
    let rect = frame
    UIView.animate(withDuration: 0.3, animations: {
      self.frame = CGRect(x: -rect.size.width, y: 0, width: rect.size.width, height: rect.size.height)
    }, completion: {(f : Bool) -> Void in
      self.windowLevel = UIWindowLevelNormal - 1
      UIApplication.shared.delegate?.window!?.makeKeyAndVisible()
     
      if completion != nil {
        completion!(f)
      }
    })
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
