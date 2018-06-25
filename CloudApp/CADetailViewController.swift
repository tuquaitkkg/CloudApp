
//
//  CADetailViewController.swift
//  CloudApp
//
//  Created by Vinh The on 1/9/17.
//  Copyright © 2017 Vinh The. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class CADetailViewController: CABaseViewController {
  
  var cloudFile: CloudFile?
  
  @IBOutlet weak var optionImageView: UIImageView!
  
  @IBOutlet weak var optionButton: UIButton!
  
  lazy var textView : UITextView = {
  
    let textView = UITextView()
    textView.isEditable = false
    return textView
    
  }()
  
  lazy var myImageView : UIImageView = {
    
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
    
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    let shareBarButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButton))
    
    navigationItem.rightBarButtonItem = shareBarButton
    
    optionButton.layer.cornerRadius = 5.0
    
    checkingTypeOfFile()
  }
  
  func shareButton() {
    
    let activity = UIActivityViewController(activityItems: [URL(string: (cloudFile?.content_url)!)!], applicationActivities: nil)
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      activity.popoverPresentationController?.sourceView = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 200))
      activity.popoverPresentationController?.sourceRect = CGRect.init(x: 0, y: 0, width: 200, height: 200)
    }
    
    self.present(activity, animated: true, completion: nil)
    
  }
  
  
  @IBAction func optionButtonAction(_ sender: Any) {
    
    guard let type = cloudFile?.item_type else {
      return
    }
    
    switch type {
    case "audio","video":
      playVideoAndAudio()
    case "archive":
      shareButton()
    default:
      shareButton()
    }
    
  }
  
  func playVideoAndAudio() {
    let videoURL = NSURL(string: (cloudFile?.content_url)!)
    let player = AVPlayer(url: videoURL! as URL)
    let playerViewController = AVPlayerViewController()
    playerViewController.player = player
    self.present(playerViewController, animated: true) {
      playerViewController.player!.play()
    }

  }
  
//  case image = "image"
//  case zip = "archive"
//  case text = "text"
//  case audio = "audio"
//  case video = "video"
  func checkingTypeOfFile() {
    
    guard let type = cloudFile?.item_type else { return }
    
    switch type {
    case "image":
      imageType()
    case "archive":
      archive()
    case "text":
      textType()
    case "audio":
      audioAndVideoType(type: type)
    case "video":
      audioAndVideoType(type: type)
    default:
      archive()
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    addChartbootsAds()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    createAdmob()
  }

  // MARK: Case Type Functions
  func audioAndVideoType(type : String) {
    
    optionButton.isHidden = false
    optionImageView.isHidden = false
    
    if type == "audio" {
      optionImageView.image = #imageLiteral(resourceName: "audio-player.png")
    }else{
      optionImageView.image = #imageLiteral(resourceName: "video-player.png")
    }
    
  }

  func archive() {
    
    optionButton.isHidden = false
    optionButton.isHidden = false
    
    optionImageView.image = #imageLiteral(resourceName: "archived.png")
    optionButton.setTitle("Open", for: .normal)
    
  }
  
  func imageType() {
    optionButton.isHidden = true
    optionImageView.isHidden = true
    
    myImageView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    
    view.addSubview(myImageView)
    
    let url = URL(string: (cloudFile?.content_url)!)
    
    startIndicator(message: "Loading Image...")
    getImageFromUrl(url: url!) { (data, response, error) in
        DispatchQueue.main.async() {
            self.myImageView.image = UIImage(data: data!)
            self.stopAnimating()
        }
        
    }
//    myImageView.downloadedFrom(url: url!) {
//      self.stopAnimating()
//    }
    
  }
  
  func textType() {
    
    optionButton.isHidden = true
    optionImageView.isHidden = true
    
    textView.frame = CGRect(x: 0.0, y: 64.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    
    view.addSubview(textView)
    
    let url = URL(string: (cloudFile?.content_url)!)
    
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
    func getImageFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        print("Download Started")
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
        
    }
  
}


