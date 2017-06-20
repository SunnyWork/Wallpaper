//
//  WallPaperViewController.swift
//  LoseWeightWallpaper
//
//  Created by Qing Jiao on 14/6/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PaperListView: UIView, ClickImgDelegate {
  var selectCallback: ((UIImage) -> Void)?
  var imageArr: [String] = []
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    var wholeArray = Array(1...90)
    wholeArray.shuffle()
    
    for one in wholeArray {
      imageArr.append("image\(one).jpg")
    }
    
    let imageView = PSY3D_CircleAnimationView()
    imageView.animationDurtion = 0
    imageView.duration = 0.5
    imageView.delegate = self
    imageView.animationType = PSY3DAnimationTpye.moveIn
    imageView.toLeftSubtype = PSY3DDirectionSubtype.fromRight
    imageView.toRightSubtype = PSY3DDirectionSubtype.fromLeft
    imageView.psy3D_ImageDataSource = imageArr
    
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.leading.trailing.top.bottom.equalTo(self)
    }
  }
  
  func clickImg(_ index: Int) {
    guard index >= 0 && index < imageArr.count else {
      return
    }
    
    if let image = UIImage(named: imageArr[index]) {
      selectCallback?(image)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class WallPaperViewController: AdBaseViewController {
  
  func closeAction() {
    self.dismiss(animated: true, completion: nil)
    
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.black
    
    let bgV = PaperListView()
    view.addSubview(bgV)
    bgV.snp.makeConstraints { make in
      make.top.trailing.leading.bottom.equalTo(view)
    }
    
    bgV.selectCallback = { image in
      self.didSelectImage(image)
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
    
    let titleLabel = UILabel()
    titleLabel.text = "swipe see more, click save"
    titleLabel.font = FontType.Regular.font(size: 20)
    titleLabel.textColor = .white
    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.top.equalTo(view).offset(30)
    }
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(4)) {
      titleLabel.removeFromSuperview()
    }
    
  }
  
  func didSelectImage(_ image: UIImage) {
   UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    
    let alert = UIAlertController(title: "Completed", message: "Image has been saved!", preferredStyle: .alert)
    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
  }
  
}

