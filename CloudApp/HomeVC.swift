//
//  HomeVC.swift
//  CloudApp
//
//  Created by DAO VAN UOC on 6/13/18.
//  Copyright © 2018 Vinh The. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON
import Alamofire
import DGElasticPullToRefresh
import MobileCoreServices
import GoogleMobileAds
class HomeVC: CABaseViewController {
    var interstitial: GADInterstitial!
    var isDelete = false
    @IBOutlet weak var progressbar: UIProgressView!
    @IBOutlet weak var viewDoc: ViewInfo!
    @IBOutlet weak var viewFile: ViewInfo!
    @IBOutlet weak var viewMusic: ViewInfo!
    @IBOutlet weak var viewContact: ViewInfo!
    @IBOutlet weak var viewVideo: ViewInfo!
    @IBOutlet weak var viewPhoto: ViewInfo!
    @IBOutlet weak var viewAvailable: ViewInfo!
    @IBOutlet weak var viewUser: ViewInfo!
    @IBOutlet weak var lbAvailable: UILabel!
    @IBOutlet weak var viewStorage: ViewInfo!
    @IBOutlet weak var clvContent: UICollectionView!
    @IBOutlet weak var viewInfo: UIView!

    fileprivate var nextHrefURL : String?
    fileprivate var files = [CloudFile]()
    fileprivate var listHome = [HomeObject]()
    fileprivate var listPhoto = [CloudFile]()
    fileprivate var listVideo = [CloudFile]()
    fileprivate var listContact = [CloudFile]()
    fileprivate var listMusic = [CloudFile]()
    fileprivate var listFile = [CloudFile]()
    fileprivate var listDocument = [CloudFile]()
    fileprivate let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestItems {
            self.viewPhoto.lbContent.text = String.init(format: "%d file", self.listPhoto.count)
            self.viewVideo.lbContent.text = String.init(format: "%d file", self.listVideo.count)
            self.viewContact.lbContent.text = String.init(format: "%d file", self.listContact.count)
            self.viewMusic.lbContent.text = String.init(format: "%d file", self.listMusic.count)
            self.viewFile.lbContent.text = String.init(format: "%d file", self.listFile.count)
            self.viewDoc.lbContent.text = String.init(format: "%d file", self.listDocument.count)
        }
        createAndLoadInterstitial()
        self.initData()
        self.initLayout()
        let image = UIImage(named: "ic_Add")
        let uploadBarButton =  UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(uploadActionSheet(sender:)))
        navigationItem.rightBarButtonItem = uploadBarButton
        
        let imageSetting = UIImage(named: "ic_Setting")
        let settingBarButton =  UIBarButtonItem(image: imageSetting, style: .plain, target: self, action: #selector(settingActionSheet(sender:)))
        navigationItem.leftBarButtonItem = settingBarButton
//         defaults.set(1, forKey: "switch")
//        let swit = UserDefaults.standard.integer(forKey: "switch")
//        if swit == 1{
//            let controller = PasscodeViewController()
//            controller.isMain = true
//            self.present(controller, animated: true, completion: {
//                let alertView = UIAlertController(title: "Password", message: "Please, register password", preferredStyle: .alert)
//                let actionYes = UIAlertAction(title: "Yes", style: .default, handler: nil)
//                alertView.addAction(actionYes)
//                self.present(alertView, animated: true, completion: nil)
//            })
//        }
        
        
    }
    func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: keyInterstitial)
        let request = GADRequest()
        interstitial.load(request)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isDelete == true {
            self.isDelete = false
            self.requestItems {
                self.viewPhoto.lbContent.text = String.init(format: "%d file", self.listPhoto.count)
                self.viewVideo.lbContent.text = String.init(format: "%d file", self.listVideo.count)
                self.viewContact.lbContent.text = String.init(format: "%d file", self.listContact.count)
                self.viewMusic.lbContent.text = String.init(format: "%d file", self.listMusic.count)
                self.viewFile.lbContent.text = String.init(format: "%d file", self.listFile.count)
                self.viewDoc.lbContent.text = String.init(format: "%d file", self.listDocument.count)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initLayout() -> Void {
        self.viewInfo.layer.masksToBounds = true
        self.viewInfo.layer.cornerRadius = 20
        self.clvContent.delegate = self
        self.clvContent.dataSource = self
        self.clvContent.register(UINib(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
    }
    
    func initData() -> Void {
        let photo = HomeObject(title: "PHOTO", image: "ic_Photo")
        self.listHome.append(photo)
        
        let video = HomeObject(title: "VIDEO", image: "ic_Video")
        self.listHome.append(video)
        
        let music = HomeObject(title: "MUSIC", image: "ic_Music")
        self.listHome.append(music)
        
        let file = HomeObject(title: "FILE", image: "ic_File")
        self.listHome.append(file)
        
        let contact = HomeObject(title: "OTHER", image: "ic_Other")
        self.listHome.append(contact)
        
        let doc = HomeObject(title: "DOCUMENT", image: "ic_Document")
        self.listHome.append(doc)
        
        self.lbAvailable.text = UIDevice.current.freeDiskSpaceInGB
        self.viewStorage.lbContent.text = UIDevice.current.totalDiskSpaceInGB
        self.viewAvailable.lbContent.text = UIDevice.current.freeDiskSpaceInGB
        self.viewUser.lbContent.text = UIDevice.current.usedDiskSpaceInGB
        
    }
    
    //MARK :Method
    
    func dateString() -> String {
        
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        
        return dateFormatter.string(from: currentDate)
    }
    
    func settingActionSheet(sender : AnyObject) -> Void {
        let controller = SettingViewController(nibName: "SettingViewController", bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func uploadActionSheet(sender : AnyObject) {
        
        let uploadAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let fromClipboardAction = UIAlertAction(title: "New Document", style: .default) { (_) in
            
            let controller = CreatDocumentVC(nibName: "CreatDocumentVC", bundle: nil)
            controller.doSave = { content in
                let dataForUpload = content.data(using: .utf8)
                
                self.prepareForUploadItem(fileName: "Text \(self.dateString()).txt", dataUpload: dataForUpload!, mimeType: "text/*")
            }
            self.navigationController?.pushViewController(controller, animated: true)
            
            
            
            
        }
        
        let fromCameraRoll = UIAlertAction(title: "From Camera Roll", style: .default) { (_) in
            
            self.pickingImage()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        uploadAlertController.addAction(fromClipboardAction)
        uploadAlertController.addAction(fromCameraRoll)
        uploadAlertController.addAction(cancelAction)
        
        if let popoverController = uploadAlertController.popoverPresentationController {
            popoverController.barButtonItem = sender as? UIBarButtonItem
        }
        
        present(uploadAlertController, animated: true, completion: nil)
    }
    
    func prepareForUploadItem(fileName : String, dataUpload : Data, mimeType : String) {
        
        let parameter = ["name" : fileName,
                         "file_size" : 2000000] as [String : Any]
        
        
        Router.shared.uploadItem(parameter: parameter, success: { (result) in
            
            let jsonResult = JSON(result!)
            
            let s3 = S3(s3Information: jsonResult)
            
            self.uploadFileToS3(s3, data: dataUpload, fileName: fileName, mimeType: mimeType)
            
        }) { (statusCode) in
            if statusCode != nil{
                self.normalAlert(title: "Error", message: self.ErrorsDescription(result: statusCode as! Int), completionHandle: nil)
            }else{
                self.normalAlert(title: "Error", message: "Can't connect to server!", completionHandle: nil)
            }
            
        }
    }
    
    func uploadFileToS3(_ s3: S3, data : Data, fileName : String, mimeType : String) {
        
        let params = s3.s3Parameter
        
        Alamofire.upload(multipartFormData: { (multipartForm) in
            
            for (key, value) in params{
                
                multipartForm.append(value.data(using: .utf8)!, withName: key)
                
            }
            
            multipartForm.append(data, withName: "file", fileName: fileName, mimeType: mimeType)
            
        }, to: s3.url, method : .post, headers:["Accept":"application/json"]) { (encodingResult) in
            
            guard let userInfor = UserDefaults.standard.dictionary(forKey: "UserInformation") else {
                return
            }
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.authenticate(user: userInfor["email"]! as! String, password: userInfor["password"]! as! String)
                
                self.progressbar.isHidden = false
                upload.uploadProgress(closure: { (progress) in
                    
                    self.progressbar.progress = Float(progress.fractionCompleted)
                    
                })
                
                upload.responseJSON{ response in
                    
                    self.progressbar.isHidden = true
                    
                    let result = JSON(response.result.value!)
                    let file = CloudFile(fileInformation: result)
                    
                    self.files.append(file)
                    
                    DispatchQueue.main.async {
                        self.listPhoto = self.files.filter({ (object) -> Bool in
                            return object.item_type == "image"
                        })
                        self.listVideo = self.files.filter({ (object) -> Bool in
                            return object.item_type == "video"
                        })
                        self.listContact = self.files.filter({ (object) -> Bool in
                            return object.item_type == "other"
                        })
                        self.listMusic = self.files.filter({ (object) -> Bool in
                            return object.item_type == "audio"
                        })
                        self.listFile = self.files.filter({ (object) -> Bool in
                            return object.item_type == "archive"
                        })
                        self.listDocument = self.files.filter({ (object) -> Bool in
                            return object.item_type == "text"
                        })
                        self.viewPhoto.lbContent.text = String.init(format: "%d file", self.listPhoto.count)
                        self.viewVideo.lbContent.text = String.init(format: "%d file", self.listVideo.count)
                        self.viewContact.lbContent.text = String.init(format: "%d file", self.listContact.count)
                        self.viewMusic.lbContent.text = String.init(format: "%d file", self.listMusic.count)
                        self.viewFile.lbContent.text = String.init(format: "%d file", self.listFile.count)
                        self.viewDoc.lbContent.text = String.init(format: "%d file", self.listDocument.count)
                    }
                    
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        
    }
    
    func requestItems(completionHandle : @escaping ()->Void) {
        
        files.removeAll()
        
        startIndicator(message: "Loading items...")
        
        Router.shared.getItem(success: { (result) in
            
            let resultJSON = JSON(result!)
            
            let links = resultJSON["links"].dictionaryObject
            
            let nextURL = links?["next_url"] as? [String : String]
            
            if let nextURL = nextURL{
                
                self.nextHrefURL = nextURL["href"]
                
            }
            
            for fileJson in resultJSON.arrayValue{
                
                print(fileJson)
                
                let cloudFile = CloudFile(fileInformation: fileJson)
                
                self.files.append(cloudFile)
            }
            
            self.stopAnimating()
            
            self.listPhoto = self.files.filter({ (object) -> Bool in
                return object.item_type == "image"
            })
            self.listVideo = self.files.filter({ (object) -> Bool in
                return object.item_type == "video"
            })
            self.listContact = self.files.filter({ (object) -> Bool in
                return object.item_type == "other"
            })
            self.listMusic = self.files.filter({ (object) -> Bool in
                return object.item_type == "audio"
            })
            self.listFile = self.files.filter({ (object) -> Bool in
                return object.item_type == "archive"
            })
            self.listDocument = self.files.filter({ (object) -> Bool in
                return object.item_type == "text"
            })
            completionHandle()
            
        }) { (statusCode) in
            
            self.stopAnimating()
            if statusCode != nil{
                self.normalAlert(title: "Error", message: self.ErrorsDescription(result: statusCode as! Int), completionHandle: nil)
            }else{
                self.normalAlert(title: "Error", message: "No connect to server!", completionHandle: nil)
            }
            
            
        }
    }
}

extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listHome.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.configCell(object: self.listHome[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
        let object = self.listHome[indexPath.row]
        let controller = FilesDetailsVC(nibName: "FilesDetailsVC", bundle: nil)
        controller.titleNavi = object.title
        controller.funcDelete = {
            self.isDelete = true
        }
        switch indexPath.row {
        case 0:
            controller.listContent = self.listPhoto
            break
        case 1:
            controller.listContent = self.listVideo
            break
        case 2:
            controller.listContent = self.listMusic
            break
        case 3:
            controller.listContent = self.listFile
            break
        case 4:
            controller.listContent = self.listContact
            break
        case 5:
            controller.listContent = self.listDocument
            break
        default:
            break
        }
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.clvContent.frame.size.width/2-2, height: self.clvContent.frame.size.height/3-2 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
}

extension HomeVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func pickingImage() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.delegate = self
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //2
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == (kUTTypeMovie as String){
            let videoUrl = info[UIImagePickerControllerMediaURL] as! URL
            
            let videoName = "Video \(dateString()).mp4"
            
            let videoData = NSData(contentsOf: videoUrl) as! Data
            
            if videoData.count > 2000000 {
                
                dismiss(animated:true, completion: { _ in
                    self.normalAlert(title: "Warning", message: "This file too lager", completionHandle: nil)
                })
            }else{
                prepareForUploadItem(fileName: videoName, dataUpload: videoData, mimeType: "video/mp4")
                
                dismiss(animated:true, completion: nil)
            }
            
        }else{
            
            let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            let imageData = UIImagePNGRepresentation(chosenImage)
            
            let imageName = "Image \(dateString()).png"
            
            prepareForUploadItem(fileName: imageName, dataUpload: imageData!, mimeType: "image/png")
            
            dismiss(animated:true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

