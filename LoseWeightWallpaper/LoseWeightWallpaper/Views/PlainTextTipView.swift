//
//  PlainTextTipView.swift
//  Driver
//
//  Created by Qing Jiao on 12/6/17.
//  Copyright © 2017 GrabTaxi Holdings Pte Ltd. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class TriangleView: UIView {
  override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    self.backgroundColor = DesignColor.Desire
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    let size = bounds.size
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: size.height + 1))
    path.addLine(to: CGPoint(x: size.width / 2, y: 0))
    path.addLine(to: CGPoint(x: size.width, y: size.height + 1))
    path.addClip()
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
    super.draw(rect)
  }
}

class PlainTextTipView: UIView {
  private let disposeBag = DisposeBag()
  let triangle : UIView
  
  init(text: String) {
    triangle = TriangleView(frame: CGRect(x: 36, y: 0, width: 12, height: 7))
    super.init(frame: CGRect.zero)
    
    triangle.backgroundColor = DesignColor.Desire
    addSubview(triangle)
    triangle.snp.makeConstraints { make in
      make.top.equalTo(self)
      make.leading.equalTo(self).offset(14)
      make.width.equalTo(12)
      make.height.equalTo(7)
    }
    
    let textView = UIView()
    insertSubview(textView, belowSubview: triangle)
    textView.layer.shadowColor   = UIColor.black.cgColor
    textView.layer.shadowOffset  = CGSize(width: 0, height: -2)
    textView.layer.shadowRadius  = 2
    textView.layer.shadowOpacity = 0.15
    textView.layer.cornerRadius = 2
    textView.backgroundColor = DesignColor.Desire
    textView.snp.makeConstraints { make in
      make.top.equalTo(triangle.snp.bottom)
      make.leading.bottom.trailing.equalTo(self)
    }
    
    let detailLabel = UILabel()
    detailLabel.textColor = UIColor.white
    detailLabel.font = FontType.Regular.font(size: 13)
    detailLabel.textAlignment = .center
    detailLabel.numberOfLines = 0
    detailLabel.text = text
    
    textView.addSubview(detailLabel)
    detailLabel.snp.makeConstraints { make in
      make.leading.top.equalTo(textView).offset(8)
      make.trailing.bottom.equalTo(textView).offset(-8)
    }
    
    let tapG = UITapGestureRecognizer()
    self.addGestureRecognizer(tapG)
    tapG.rx.event.subscribe(onNext: { [unowned self] _ in
      self.hide()
    }).addDisposableTo(self.disposeBag)
  }
  
  func show() {
    self.alpha = 0
    UIView.animate(withDuration: 0.3, animations: {
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
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
