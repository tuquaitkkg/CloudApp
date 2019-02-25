//
//  CABaseViewController.swift
//  CloudApp
//
//  Created by Vinh The on 1/4/17.
//  Copyright © 2017 Vinh The. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CABaseViewController: UIViewController, NVActivityIndicatorViewable {
  
  var bannerView1 : GADBannerView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isTranslucent = false
    self.navigationController?.navigationBar.barTintColor = APP_COLOR
    self.navigationController?.navigationBar.tintColor = UIColor.white
    
    let navigationTitleFont = UIFont.systemFont(ofSize: 22)
    
    self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont, NSForegroundColorAttributeName:UIColor.white]

    // Do any additional setup after loading the view.
  }
  
  func normalAlert(title: String, message: String,completionHandle : ((UIAlertAction)->Void)?) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: .default, handler: completionHandle)
    
    alertController.addAction(okAction)
    
    present(alertController, animated: true, completion: nil)
    
  }
  
  func startIndicator(message : String) {
    startAnimating(CGSize(width: 50, height: 50), message: message, messageFont: nil, type: .ballClipRotate, color: .white, padding: 0.0, displayTimeThreshold: nil, minimumDisplayTime: nil)
  }
  
  func ErrorsDescription(result : Int) -> String {
    
    switch result {
    case 401:
      return ConnectionError.authenticationFailed.description
    case 422:
      return ConnectionError.wrongRequestData.description
    case 500:
      return ConnectionError.serverError.description
    case 503:
      return ConnectionError.servicesUnavailable.description
    default:
      return "Error can not verify"
      
    }
    
  }
  
}

extension CABaseViewController : ChartboostDelegate,GADBannerViewDelegate{
  
  func addChartbootsAds() {
    let elapsed = Date().timeIntervalSince(kChartBoostTime)
    
    if Int(elapsed) > kTime {
      print("Show ChartBoost")
      
      kChartBoostTime = Date()
      
      Chartboost.start(withAppId: kChartBoostAppID, appSignature: kChartBoostAppSignature, delegate: self)
      
      Chartboost.cacheInterstitial(CBLocationHomeScreen)
      Chartboost.cacheRewardedVideo(CBLocationHomeScreen)
      
      if Chartboost.hasInterstitial(CBLocationHomeScreen) {
        Chartboost.showInterstitial(CBLocationHomeScreen)
      }else{
        Chartboost.cacheInterstitial(CBLocationHomeScreen)
      }
      
      if Chartboost.hasRewardedVideo(CBLocationHomeScreen) {
        Chartboost.showRewardedVideo(CBLocationHomeScreen)
      }else{
        Chartboost.cacheRewardedVideo(CBLocationHomeScreen)
      }
      
      Chartboost.setShouldRequestInterstitialsInFirstSession(true)
    }else{
      print("ChartBoost not showing")
    }
  }

  func createAdmob() {
    var yOrigin : CGFloat = 0
    
    switch UIDevice.current.userInterfaceIdiom {
    case .pad:
      yOrigin = 90.0
    case .phone:
      yOrigin = 50.0
    case .unspecified:
      yOrigin = 50.0
    default:
      yOrigin = 50.0
    }
    
    if bannerView1 == nil {
      bannerView1 = GADBannerView(adSize:kGADAdSizeSmartBannerPortrait,origin: CGPoint(x: 0, y: view.bounds.size.height - yOrigin))
      bannerView1?.center.x = view.center.x
      bannerView1?.delegate = self
      bannerView1?.adUnitID = keyBanner
      bannerView1?.rootViewController = self
      self.view.addSubview(bannerView1!)
      bannerView1?.load(GADRequest())
    }
    
  }
  
  func didFail(toLoadInterstitial location: String!, withError error: CBLoadError) {
    print(location, error)
  }
  
  func didFail(toLoadRewardedVideo location: String!, withError error: CBLoadError) {
    print(location, error)
  }

  
  func adViewDidReceiveAd(_ bannerView: GADBannerView) {
    print("did receiveAd")
  }
  
  func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
    print(error)
  }
    
    func setTitle(text : String) {
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        label.text = text
        label.textAlignment = .center
        label.textColor = UIColor.white
        self.navigationItem.titleView = label
    }
  
}
