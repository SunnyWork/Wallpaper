//
//  AdBaseViewController.swift
//  LoseWeightWallpaper
//
//  Created by Qing Jiao on 14/6/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdBaseViewController: UIViewController {
  var bannerView: GADBannerView!

  override func viewDidLoad() {
    super.viewDidLoad()
   
    bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    bannerView.adUnitID = adUit
    bannerView.rootViewController = self
    let request = GADRequest()
    request.testDevices = [ kGADSimulatorID, "39fb59212590926492a7b138effe9578" ];
    bannerView.load(request)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    view.addSubview(bannerView)
    bannerView.bottomToSuper = 0
  }
}

