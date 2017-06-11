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


class SportViewController: UIViewController {
  fileprivate let headerView = UIView()
  fileprivate let reasonView = UIView()
  fileprivate let titleLabel = UILabel()
  fileprivate let coverView = UIImageView()

  fileprivate var totTime = 30 //mins
  fileprivate var countDown = 1800 //s
  fileprivate var timer: Timer?
  
  fileprivate var totalTime: Int {
    set{
      totTime = newValue
      countDown = newValue * 60
      resetTimer()
    }
    get{
      return totTime
    }
  }
  
  func resetTimer() {
    timer?.invalidate()
    timer = nil
    
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
  }
  
  func update() {
    countDown -= 1
    guard countDown > 0 else {
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
    
  }
  
  func showIncentiveIfNeeded() {
//    if (totTime * 60 - countDown) 
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let bgV = UIImageView()
    view.addSubview(bgV)
    bgV.image = R.image.sport_bg_1()
    bgV.contentMode = .scaleAspectFill
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
      self.dismiss(animated: true, completion: nil)
    })
    
    buildHeaderView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let inputView = InputView(labelText: "Set Time(mins)", callback: {
      [unowned self] newTime in
      self.totalTime = newTime
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
    
    titleLabel.text = "40m 44s"
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

