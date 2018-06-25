
//
//  DetailsVC.swift
//  CloudApp
//
//  Created by DAO VAN UOC on 6/19/18.
//  Copyright © 2018 Vinh The. All rights reserved.
//

import UIKit
import GoogleMobileAds
class DetailsVC: CABaseViewController {
    var bannerView: GADBannerView!
    var type = ""
    var url = ""
    lazy var textView : UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        return textView
        
    }()
    
    lazy var myImageView : UIImageView = {
        
        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == "text" {
            textType(url: url)
        }else{
            imageType(url: url)
        }
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = keyBanner
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
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
    
    func imageType(url:String) {
        myImageView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        view.addSubview(myImageView)
        let url = URL(string: url)
        startIndicator(message: "Loading Image...")
        getImageFromUrl(url: url!) { (data, response, error) in
            DispatchQueue.main.async() {
                self.myImageView.image = UIImage(data: data!)
                self.stopAnimating()
            }
        }
    }
    
    func getImageFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        print("Download Started")
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
        
    }
    
    func textType(url:String) {
        
        textView.frame = CGRect(x: 0.0, y: 5.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        view.addSubview(textView)
        
        let url = URL(string: url)
        
        startIndicator(message: "Loading Text...")
        loadTextData(url: url!) { (string) in
            print(string)
            self.textView.text = string
            self.stopAnimating()
        }
    }
    
    func loadTextData(url : URL, completionHandle : @escaping (String)->Void) {
        DispatchQueue.global().async {
            do {
                let textData = try Data(contentsOf: url)
                let textString = String(data: textData, encoding: .utf8)
                DispatchQueue.main.async {
                    completionHandle(textString!)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


