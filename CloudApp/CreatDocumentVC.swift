//
//  CreatDocumentVC.swift
//  CloudApp
//
//  Created by DAO VAN UOC on 6/19/18.
//  Copyright © 2018 Vinh The. All rights reserved.
//

import UIKit
import GoogleMobileAds
class CreatDocumentVC: CABaseViewController {
    var interstitial: GADInterstitial!
    var doSave:((String)->())?
    var bannerView: GADBannerView!
    @IBOutlet weak var tvContent: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = keyBanner
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        self.title = "New Document"
        self.tvContent.layer.masksToBounds = true
        self.tvContent.layer.borderWidth = 1
        self.tvContent.layer.borderColor = UIColor.lightGray.cgColor
        self.tvContent.layer.cornerRadius = 5
        let uploadBarButton = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(uploadActionSheet(sender:)))
        
        navigationItem.rightBarButtonItem = uploadBarButton
        self.tvContent.becomeFirstResponder()
        createAndLoadInterstitial()
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }

    func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: keyInterstitial)
        let request = GADRequest()
        interstitial.load(request)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func uploadActionSheet(sender : AnyObject) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
        if tvContent.text.count > 0 {
            if self.doSave != nil{
                self.doSave!(tvContent.text)
            }
            self.navigationController?.popViewController(animated: true)
        }else{
            self.normalAlert(title: "Alert", message: "Please enter content!", completionHandle: nil)
        }
    }
}
