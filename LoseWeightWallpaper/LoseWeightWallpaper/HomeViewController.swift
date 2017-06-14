//
//  HomeViewController.swift
//  LoseWeightWallpaper
//
//  Created by Qing Jiao on 4/6/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
  fileprivate let disposeBag = DisposeBag()
  
  fileprivate let progress = DSGradientProgressView()
  fileprivate let headerView = UIView()
  fileprivate let reasonView = UIView()
  fileprivate let coverView = UIImageView()
  
  fileprivate let initLabel = UILabel()
  fileprivate let currentLabel = UILabel()
  fileprivate let targetLabel = UILabel()
  
  fileprivate let reasonLabel = UILabel()
  
  fileprivate var sayHello = false
  
  fileprivate var menuWindow : MenuWindow = {
    let swindow = MenuWindow(frame :UIScreen.main.bounds)
    return swindow
  }()
  
  
  let weightTip = PlainTextTipView(text: "Click number to update!")
  let reasonTip = PlainTextTipView(text: "Click here to update!")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let bgV = UIImageView()
    view.addSubview(bgV)
    bgV.image = R.image.bg_1()
    bgV.contentMode = .scaleAspectFill
    bgV.snp.makeConstraints { make in
      make.top.trailing.leading.bottom.equalTo(view)
    }
    
    buildHeaderView()
    
    buildReasonView()
    
    buildBottomView()
    
    resetLabelValue()
    
    
    currentLabel.isUserInteractionEnabled = true
    var tapG = UITapGestureRecognizer()
    currentLabel.addGestureRecognizer(tapG)
    tapG.rx.event.subscribe(onNext: { [unowned self] _ in
      self.updateCurrentView()
    }).addDisposableTo(self.disposeBag)
    
    reasonLabel.isUserInteractionEnabled = true
    tapG = UITapGestureRecognizer()
    reasonLabel.addGestureRecognizer(tapG)
    tapG.rx.event.subscribe(onNext: { [unowned self] _ in
      self.updateReason()
    }).addDisposableTo(self.disposeBag)
  }
  
  fileprivate func updateCurrentView() {
    let inputView = InputTimeView(labelText: "Update your weight", callback: {
      [unowned self] value in
      DataContainer.shared.currentWeight = Int(value)
      self.resetLabelValue()
      self.weightTip.hide()
    })
    
    view.addSubview(inputView)
    inputView.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.top.equalTo(view).offset(100)
      make.width.equalTo(view).offset(-20)
    }
    
    inputView.show()
  }
  
  fileprivate func updateReason() {
    let inputView = InputTimeView(labelText: "Why you do it!", callback: {
      [unowned self] value in
      guard !value.isEmpty else { return }
      DataContainer.shared.reason = value
      self.resetLabelValue()
      self.reasonTip.hide()
      }, inputType: InputType.string)
    
    view.addSubview(inputView)
    inputView.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.top.equalTo(view).offset(100)
      make.width.equalTo(view).offset(-20)
    }
    
    inputView.show()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    guard DataContainer.shared.targetWeight == nil else { return }
    
    showSetTargetView(closeEable: false)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    guard DataContainer.shared.targetWeight != nil else { return }
    guard !sayHello else { return }
    
    sayHello = true
    showHello()
  }
  
  fileprivate func resetLabelValue() {
    guard let initW = DataContainer.shared.initWeight else { return }
    guard let curW = DataContainer.shared.currentWeight else { return }
    guard let tarW = DataContainer.shared.targetWeight else { return }
    guard let reason = DataContainer.shared.reason else { return }
    
    initLabel.text = "\(initW)Kg"
    currentLabel.text = "\(curW)Kg"
    targetLabel.text = "\(tarW)Kg"
    reasonLabel.text = reason
    
    self.view.setNeedsLayout()
    
    if curW <= tarW {
      finishSport()
    }
  }
  
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    resetProgressBar()
  }
  
  fileprivate func resetProgressBar() {
    guard let initW = DataContainer.shared.initWeight else { return }
    guard let curW = DataContainer.shared.currentWeight else { return }
    guard let tarW = DataContainer.shared.targetWeight else { return }
    
    var rect = progress.frame
    let diff: CGFloat = CGFloat(initW - tarW)
    rect.size.width *= 1 - CGFloat(curW - tarW) / diff
    
    coverView.frame = rect
    
    let ny = rect.origin.y - rect.size.height - 12
    let nx = min(rect.origin.x + rect.size.width - 20, headerView.frame.size.width - 52)
    rect.origin.x = max(nx, 0)
    rect.origin.y = ny
    rect.size.height += 8
    rect.size.width = 58
    
    currentLabel.frame = rect
  }
  
}

extension HomeViewController {
  fileprivate func showHello() {
    let iv = UIImageView()
    iv.image = R.image.emoji_hello()
    view.addSubview(iv)
    
    let fv = UIImageView()
    fv.image = R.image.emoji_fight()
    view.addSubview(fv)
    
    iv.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
    iv.center = view.center
    fv.frame = iv.frame
    
    UIView.animate(withDuration: 1, animations: {
      iv.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
      iv.center = self.view.center
    }, completion: { _ in
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
        iv.removeFromSuperview()
        
        UIView.animate(withDuration: 0.5, animations: {
          fv.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
          fv.center = self.view.center
        }, completion: { _ in
          DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            fv.removeFromSuperview()
          }
        })
      }
    })
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
  
  fileprivate func showTutorial() {
    guard !DataContainer.shared.tipsShowedBefore else { return }
    DataContainer.shared.tipsShowedBefore = true
    
    headerView.addSubview(weightTip)
    weightTip.snp.makeConstraints{make in
      make.width.equalTo(110)
      make.top.equalTo(currentLabel.snp.bottom).offset(5)
      make.leading.equalTo(currentLabel).offset(-5)
    }
    
    view.addSubview(reasonTip)
    reasonTip.snp.makeConstraints{make in
      make.width.equalTo(110)
      make.top.equalTo(reasonLabel.snp.bottom).offset(5)
      make.leading.equalTo(reasonLabel).offset(10)
    }
  }
  
  fileprivate func showSetTargetView(closeEable: Bool) {
    let inputView = InputTargetView() {
      [unowned self] targetWeight, currentWeight, reason in
      DataContainer.shared.targetWeight = targetWeight
      DataContainer.shared.initWeight = currentWeight
      DataContainer.shared.currentWeight = currentWeight
      DataContainer.shared.reason = reason
      
      self.resetLabelValue()
      self.showTutorial()
    }
    view.addSubview(inputView)
    inputView.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.top.equalTo(view).offset(20)
      make.width.equalTo(view).offset(-20)
    }
    inputView.closeEable = closeEable
    inputView.show()
  }
}

extension HomeViewController {
  fileprivate func buildBottomView() {
    let nowBtn = UIButton()
    view.addSubview(nowBtn)
    nowBtn.layer.cornerRadius = 75
    nowBtn.backgroundColor = DesignColor.Desire.withAlphaComponent(0.8)
    nowBtn.setTitle("Do it now!", for: .normal)
    nowBtn.titleLabel?.font = FontType.Medium.font(size: 20)
    nowBtn.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.top.equalTo(reasonView.snp.bottom).offset(140)
      make.height.width.equalTo(150)
    }
    
    _ = nowBtn.rx.tap.subscribe(onNext: { [unowned self] obj in
      self.present(SportViewController(), animated: true, completion: nil)
    })
    
    let wallPaperButton = UIButton()
    wallPaperButton.layer.cornerRadius = 10
    wallPaperButton.backgroundColor = DesignColor.Desire.withAlphaComponent(0.8)
    wallPaperButton.setTitle("Select Wallpaper", for: .normal)
    wallPaperButton.titleLabel?.font = FontType.Medium.font(size: 20)
    view.addSubview(wallPaperButton)
    wallPaperButton.snp.makeConstraints { make in
      make.top.equalTo(nowBtn.snp.bottom).offset(20)
      make.width.equalTo(220)
      make.centerX.equalTo(view)
      make.height.equalTo(30)
    }
    _ = wallPaperButton.rx.tap.subscribe(onNext: { [unowned self] obj in
      self.present(WallPaperViewController(), animated: true, completion: nil)
    })
    
    let alarmButton = UIButton()
    alarmButton.layer.cornerRadius = 10
    alarmButton.backgroundColor = DesignColor.Desire.withAlphaComponent(0.8)
    alarmButton.setTitle("Set Alarm", for: .normal)
    alarmButton.titleLabel?.font = FontType.Medium.font(size: 20)
    view.addSubview(alarmButton)
    alarmButton.snp.makeConstraints { make in
      make.top.equalTo(wallPaperButton.snp.bottom).offset(20)
      make.width.equalTo(220)
      make.centerX.equalTo(view)
      make.height.equalTo(30)
    }
    _ = alarmButton.rx.tap.subscribe(onNext: { [unowned self] obj in
      let nav = BaseNavigationController(rootViewController: AlarmViewController())
      self.present(nav, animated: true, completion: nil)
    })
  }
  
  fileprivate func buildReasonView() {
    view.addSubview(reasonView)
    reasonView.layer.cornerRadius = 14
    reasonView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    reasonView.snp.makeConstraints { make in
      make.trailing.equalTo(view).offset(-7)
      make.leading.equalTo(view).offset(7)
      make.top.equalTo(headerView.snp.bottom).offset(30)
    }
    reasonView.layer.shadowColor = UIColor.black.cgColor
    reasonView.layer.shadowOffset = CGSize(width: 1, height: 1)
    reasonView.layer.shadowOpacity = 0.44
    reasonView.layer.shadowRadius = 1
    
    reasonLabel.font = FontType.Regular.font(size: 17)
    reasonLabel.textColor = .white
    reasonLabel.numberOfLines = 0
    reasonLabel.textAlignment = .center
    reasonView.addSubview(reasonLabel)
    reasonLabel.snp.makeConstraints { make in
      make.leading.equalTo(reasonView).offset(10)
      make.trailing.equalTo(reasonView).offset(-10)
      make.top.equalTo(reasonView).offset(10)
      make.bottom.equalTo(reasonView).offset(-10)
    }
  }
  
  fileprivate func buildHeaderView() {
    view.addSubview(headerView)
    headerView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
    headerView.layer.cornerRadius = 14
    
    headerView.layer.shadowColor = UIColor.black.cgColor
    headerView.layer.shadowOffset = CGSize(width: 1, height: 1)
    headerView.layer.shadowOpacity = 0.25
    headerView.layer.shadowRadius = 1
    
    headerView.snp.makeConstraints { make in
      make.trailing.equalTo(view).offset(-7)
      make.leading.equalTo(view).offset(7)
      make.top.equalTo(view).offset(20)
    }
    
    let titleLabel = UILabel()
    titleLabel.text = "You can!"
    titleLabel.font = FontType.Medium.font(size: 26)
    titleLabel.textColor = .white
    headerView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.centerX.equalTo(headerView)
      make.top.equalTo(headerView).offset(10)
    }
    
    let menuButton = UIButton()
    menuButton.setImage(R.image.icon_menu(), for: .normal)
    headerView.addSubview(menuButton)
    menuButton.snp.makeConstraints { make in
      make.leading.top.equalTo(headerView).offset(10)
      make.width.equalTo(30)
      make.height.equalTo(30)
    }
    _ = menuButton.rx.tap.subscribe(onNext: { [unowned self] obj in
      self.showMenu()
    })
    
    buildProgressView()
  }
  
  func showMenu(){
    menuWindow.makeKeyAndVisible()
    menuWindow.showAnimation(nil)
    menuWindow.setTargetCallback = { _ in
      self.showSetTargetView(closeEable: true)
    }
  }
  
  fileprivate func buildProgressView() {
    headerView.addSubview(progress)
    
    progress.barColor = DesignColor.Desire
    progress.layer.cornerRadius = 10
    
    progress.snp.makeConstraints { make in
      make.top.equalTo(headerView).offset(44 + 40)
      make.leading.equalTo(headerView).offset(2)
      make.trailing.equalTo(headerView).offset(-2)
      make.height.equalTo(20)
    }
    progress.start()
    
    headerView.addSubview(coverView)
    coverView.layer.cornerRadius = progress.layer.cornerRadius
    coverView.backgroundColor = DesignColor.Desire
    
    initLabel.font = FontType.Bold.font(size: 22)
    initLabel.textColor = UIColor.white
    headerView.addSubview(initLabel)
    initLabel.snp.makeConstraints { make in
      make.leading.equalTo(progress)
      make.top.equalTo(progress.snp.bottom).offset(9)
      make.bottom.equalTo(headerView).offset(-25)
    }
    
    currentLabel.font = FontType.Bold.font(size: 22)
    currentLabel.textColor = DesignColor.Desire
    headerView.addSubview(currentLabel)
    
    targetLabel.font = FontType.Bold.font(size: 22)
    targetLabel.textColor = .white
    headerView.addSubview(targetLabel)
    targetLabel.snp.makeConstraints { make in
      make.trailing.equalTo(progress)
      make.top.equalTo(progress.snp.bottom).offset(9)
    }
  }
  
}

