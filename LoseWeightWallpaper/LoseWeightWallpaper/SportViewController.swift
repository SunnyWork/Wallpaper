//
//  SportViewController.swift
//  LoseWeightWallpaper
//
//  Created by Qing Jiao on 11/6/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class SportViewController: AdBaseViewController {
  fileprivate let headerView = UIView()
  fileprivate let reasonView = UIView()
  fileprivate let titleLabel = UILabel()
  fileprivate let coverView = UIImageView()
  
  fileprivate let bgV = DisplayView()

  fileprivate var totTime = 0 //mins
  fileprivate var countDown = 0 //s
  fileprivate var timer: Timer?
  
  fileprivate var totalTime: Int {
    set{
      totTime = newValue * 60
      countDown = newValue * 60
      if newValue > 0 {
        resetTimer()
      }
    }
    get{
      return totTime
    }
  }
  
  func resetTimer() {
    timer?.invalidate()
    timer = nil
    
    
    showStartAnimation()
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
  }
  
  func showStartAnimation() {
    
  }
  
  func update() {
    countDown -= 1
    guard countDown >= 0 else {
      timer?.invalidate()
      timer = nil
      finishSport()
      return
    }
    
    let min = countDown / 60
    let seconds = countDown % 60
    titleLabel.text = "\(min)m \(seconds)s"
    showIncentiveIfNeeded()
  }
  
  func finishSport() {
    let one = ComeonView(text: "Oh! You are the best! You finish!", type: .finishAll)
    view.addSubview(one)
    one.snp.makeConstraints { make in
      make.centerY.centerX.equalTo(view)
      make.width.height.equalTo(view)
    }
    one.show()
    SoundManager.shared.playFinish()
  }
  
  func showIncentiveIfNeeded() {
    let interval = 5 * 60
    if (totTime - countDown) % interval == 0 {
      let text: String
      if (totTime - countDown) < interval * 2 {
        text = "Wow, you have make 5 mins, keep doing it!"
      } else {
        text = "Yeah! 5 mins more, just do another 5 mins!"
      }
      let one = ComeonView(text: text)
      view.addSubview(one)
      one.snp.makeConstraints { make in
        make.centerY.centerX.equalTo(view)
        make.width.height.equalTo(view)
      }
      one.show()
      SoundManager.shared.playWin()
    }
  }
  
  func closeAction() {
    if countDown <= 0 {
      self.dismiss(animated: true, completion: nil)
      return
    }
    
    let iv = RememberView(){
      self.dismiss(animated: true, completion: nil)
    }
    view.addSubview(iv)
    iv.snp.makeConstraints { make in
      make.leading.equalTo(view).offset(20)
      make.top.equalTo(view).offset(20)
      make.trailing.equalTo(view).offset(-20)
    }
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.black
    
    view.addSubview(bgV)
    bgV.snp.makeConstraints { make in
      make.top.trailing.leading.bottom.equalTo(view)
    }
    
    let menuButton = UIButton()
    menuButton.setImage(R.image.icon_close(), for: .normal)
    view.addSubview(menuButton)
    menuButton.snp.makeConstraints { make in
      make.leading.equalTo(view).offset(9)
      make.top.equalTo(view).offset(26)
      make.width.equalTo(35)
      make.height.equalTo(35)
    }
    _ = menuButton.rx.tap.subscribe(onNext: { [unowned self] _ in
      self.closeAction()
    })
    
    buildHeaderView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    timer?.invalidate()
    timer = nil
    
    bgV.closeDisplayTimer()
    SoundManager.shared.stop()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let inputView = InputTimeView(labelText: "Set Time(mins)", callback: {
      [unowned self] newTime in
      if let t = Int(newTime) {
        self.totalTime = t
      } else {
        self.totalTime = 30
      }
    })
    
    view.addSubview(inputView)
    inputView.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.top.equalTo(view).offset(20)
      make.width.equalTo(view).offset(-20)
    }
    
    inputView.show()
  }
  
  fileprivate func buildHeaderView() {
    view.addSubview(headerView)
    headerView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
    headerView.layer.cornerRadius = 14
    
    headerView.layer.shadowColor = UIColor.black.cgColor
    headerView.layer.shadowOffset = CGSize(width: 1, height: 1)
    headerView.layer.shadowOpacity = 0.25
    headerView.layer.shadowRadius = 1
    
    headerView.snp.makeConstraints { make in
      make.width.equalTo(189)
      make.top.equalTo(view).offset(20)
      make.centerX.equalTo(view)
    }
    
    titleLabel.text = ""
    titleLabel.font = FontType.Medium.font(size: 25)
    titleLabel.textColor = .white
    headerView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.centerX.equalTo(headerView)
      make.top.equalTo(headerView).offset(8)
      make.bottom.equalTo(headerView).offset(-10)
    }
  }
  
}

