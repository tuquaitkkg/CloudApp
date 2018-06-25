
//
//  FilesDetailsVC.swift
//  CloudApp
//
//  Created by DAO VAN UOC on 6/15/18.
//  Copyright © 2018 Vinh The. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import NVActivityIndicatorView
import SwiftyJSON
import Alamofire
import GoogleMobileAds
import DGElasticPullToRefresh
import MobileCoreServices
class FilesDetailsVC: CABaseViewController {
   var bannerView: GADBannerView!
    @IBOutlet weak var clvContent: UICollectionView!
    var listContent = [CloudFile]()
    var titleNavi = ""
    var funcDelete:(()->())?
    var isCheck = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initLayout()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = keyBanner
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        let image = UIImage(named: "ic_CheckBox")
        let uploadBarButton =  UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(uploadActionSheet(sender:)))
        navigationItem.rightBarButtonItem = uploadBarButton
    }
    
    func uploadActionSheet(sender : AnyObject) {
        isCheck = !isCheck
        clvContent.reloadData()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initLayout() -> Void {
        self.title = titleNavi
        self.clvContent.delegate = self
        self.clvContent.dataSource = self
        self.clvContent.register(UINib(nibName: "FileDetailsCell", bundle: nil), forCellWithReuseIdentifier: "FileDetailsCell")
    }
    
    // MARK: - Delete Item
    func deleteItem(id : String, indexPath : IndexPath) {
        
        startIndicator(message: "Deleting item")
        Router.shared.deleteItem(id: id, success: { (response) in
            print("Success")
            self.listContent.remove(at: indexPath.row)
            self.clvContent.deleteItems(at:  [indexPath])
            self.stopAnimating()
            if self.funcDelete != nil{
                self.funcDelete!()
            }
        }) { (statusCode) in
            
            print(statusCode as! Int)
            
            self.stopAnimating()
            
            self.normalAlert(title: "Error", message: self.ErrorsDescription(result: statusCode as! Int), completionHandle: nil)
        }
        
    }
}

extension FilesDetailsVC :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileDetailsCell", for: indexPath) as! FileDetailsCell
        if isCheck == true {
            cell.btnDelete.isHidden = false
        }else{
             cell.btnDelete.isHidden = true
        }
        cell.configureCell(file: self.listContent[indexPath.row])
        cell.btnDeleteClickClosesure = { sender in
            let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to:self.clvContent)
            let indexPath : IndexPath = self.clvContent.indexPathForItem(at: buttonPosition)!
            
            let object = self.listContent[indexPath.row]
            self.deleteItem(id: object.id!, indexPath: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.clvContent.frame.size.width/3-2, height: self.clvContent.frame.size.height/5-5 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let object = self.listContent[indexPath.row]
        guard let type = object.item_type else {
            return
        }
        
        switch type {
        case "audio","video":
            playVideoAndAudio(url: object.content_url!)
        case "archive","other":
            shareButton(url: object.content_url!)
        case "image","text":
            let controller = DetailsVC(nibName: "DetailsVC", bundle: nil)
            controller.title = object.name
            controller.url = object.content_url!
            controller.type = object.item_type!
            self.navigationController?.pushViewController(controller, animated: true)
            break
        default: break
//            shareButton()
        }
    }
    
    func shareButton(url:String) {
        
        let activity = UIActivityViewController(activityItems: [URL(string: url)!], applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activity.popoverPresentationController?.sourceView = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 200))
            activity.popoverPresentationController?.sourceRect = CGRect.init(x: 0, y: 0, width: 200, height: 200)
        }
        
        self.present(activity, animated: true, completion: nil)
        
    }
    
    func playVideoAndAudio(url:String) {
        let videoURL = NSURL(string: url)
        let player = AVPlayer(url: videoURL! as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
    }
}

