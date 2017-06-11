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
  fileprivate let headerView = UIImageView()
  fileprivate let reasonView = UIView()

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

    let reasonLabel = UILabel()
    reasonLabel.text = "Because: I don't want to admire others any more!"
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
      make.leading.top.equalTo(headerView).offset(16)
      make.width.equalTo(18)
      make.height.equalTo(12)
    }

    buildProgressView()
  }
  
  fileprivate func buildProgressView() {
    let progress = DSGradientProgressView()
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
    
    let coverView = UIImageView()
    headerView.addSubview(coverView)
    coverView.layer.cornerRadius = progress.layer.cornerRadius
    coverView.backgroundColor = DesignColor.Desire
    coverView.snp.makeConstraints { make in
      make.top.leading.height.equalTo(progress)
      make.width.equalTo(150)
    }
    
    let titleLabel = UILabel()
    titleLabel.text = "75Kg"
    titleLabel.font = FontType.Bold.font(size: 22)
    titleLabel.textColor = UIColor.white
    headerView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(progress)
      make.top.equalTo(progress.snp.bottom).offset(9)
      make.bottom.equalTo(headerView).offset(-25)
    }
    
    let nowLabel = UILabel()
    nowLabel.text = "71Kg"
    nowLabel.font = FontType.Bold.font(size: 22)
    nowLabel.textColor = UIColor.white
    headerView.addSubview(nowLabel)
    nowLabel.snp.makeConstraints { make in
      make.trailing.equalTo(coverView).offset(7)
      make.top.equalTo(progress.snp.bottom).offset(9)
    }
    
    let pLabel = UILabel()
    pLabel.text = "58Kg"
    pLabel.font = FontType.Bold.font(size: 22)
    pLabel.textColor = .white
    headerView.addSubview(pLabel)
    pLabel.snp.makeConstraints { make in
      make.trailing.equalTo(progress)
      make.top.equalTo(progress.snp.bottom).offset(9)
    }
  }

}

