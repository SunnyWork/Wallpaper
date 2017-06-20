//
//  AdBaseViewController.swift
//  LoseWeightWallpaper
//
//  Created by Qing Jiao on 14/6/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import UIKit
import GoogleMobileAds
import RxSwift

class AdBaseViewController: UIViewController {
  var bannerView: GADBannerView!
  fileprivate let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    bannerView.adUnitID = adUit
    bannerView.rootViewController = self
    let request = GADRequest()
    request.testDevices = [ kGADSimulatorID, "39fb59212590926492a7b138effe9578" ];
    bannerView.load(request)
    
    
    IAPHelper.sharedInstance.bought.asObservable().subscribe(onNext: {
      buy in
      guard buy else { return }
      self.bannerView.removeFromSuperview()
    }).addDisposableTo(self.disposeBag)
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if !IAPHelper.sharedInstance.bought.value {
      view.addSubview(bannerView)
      bannerView.bottomToSuper = 0
    }
    
  }
}

