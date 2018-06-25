//
//  CAFilesViewController.swift
//  CloudApp
//
//  Created by Vinh The on 1/3/17.
//  Copyright © 2017 Vinh The. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON
import Alamofire
import DGElasticPullToRefresh
import MobileCoreServices

class CAFilesViewController: CABaseViewController {
  
  @IBOutlet weak var progressbar: UIProgressView!
  
  let imagePicker = UIImagePickerController()
  
  var nextHrefURL : String?
		
  var files = [CloudFile]()
		
  var refreshControll : UIRefreshControl!
  
  @IBOutlet weak var filesTableView: UITableView!
  
  @IBAction func logoutAction(_ sender: Any) {
    
    let alertController = UIAlertController(title: "Log-out", message: "Are you sure ?", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
      UserDefaults.standard.set(nil, forKey: "UserInformation")
      
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.checkingAuthentication()
    })
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    alertController.addAction(okAction)
    alertController.addAction(cancelAction)
    
    present(alertController, animated: true, completion: nil)
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    addChartbootsAds()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    createAdmob()
  }
  
  @IBOutlet weak var settingContraintBottom: NSLayoutConstraint!
  override func adViewDidReceiveAd(_ bannerView: GADBannerView) {
    UIView.animate(withDuration: 0.5) {
      switch UIDevice.current.userInterfaceIdiom {
      case .pad:
        self.settingContraintBottom.constant = 90.0
      case .phone:
        self.settingContraintBottom.constant = 50.0
      case .unspecified:
        self.settingContraintBottom.constant = 50.0
      default:
        self.settingContraintBottom.constant = 50.0
      }
      
    }
  }

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    uploadBarButton()
    
    progressbar.isHidden = true
    
    imagePicker.delegate = self
    
    filesTableView.register(UINib.init(nibName: "CAFileTableViewCell", bundle: nil), forCellReuseIdentifier: "FileCell")
    
    filesTableView.separatorStyle = .none
    
    requestItems {
      self.filesTableView.reloadData()
    }
    
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
    filesTableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
      
      self?.requestItems {
        self?.filesTableView.reloadData()
      }
      self?.filesTableView.dg_stopLoading()
      }, loadingView: loadingView)
    filesTableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
    filesTableView.dg_setPullToRefreshBackgroundColor(filesTableView.backgroundColor!)
    
    
    filesTableView.addInfiniteScroll { (tableView) -> Void in
      
      if let _ = self.nextHrefURL {
        self.getNextPageItemRequest {
          self.filesTableView.reloadData()
        }
      }
      tableView.finishInfiniteScroll()
    }
    
  }
  
  func uploadBarButton() {
    
    let uploadBarButton = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(uploadActionSheet(sender:)))
    
    navigationItem.rightBarButtonItem = uploadBarButton
  }
  
  func uploadActionSheet(sender : AnyObject) {
    
    let uploadAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let fromClipboardAction = UIAlertAction(title: "From Clipboard", style: .default) { (_) in
      
      if let fileName = UIPasteboard.general.string{
        let dataForUpload = fileName.data(using: .utf8)
        
        self.prepareForUploadItem(fileName: "Text \(self.dateString()).txt", dataUpload: dataForUpload!, mimeType: "text/*")
      }
      
      
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
  
  func dateString() -> String {
    
    let currentDate = Date()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .medium
    
    return dateFormatter.string(from: currentDate)
  }
  
  deinit {
    filesTableView.dg_removePullToRefresh()
  }
  
  //MARK: - Upload Item
  
  func prepareForUploadItem(fileName : String, dataUpload : Data, mimeType : String) {
    
    let parameter = ["name" : fileName,
                     "file_size" : 2000000] as [String : Any]
    
    
    Router.shared.uploadItem(parameter: parameter, success: { (result) in
      
      let jsonResult = JSON(result!)
      
      let s3 = S3(s3Information: jsonResult)
      
      self.uploadFileToS3(s3, data: dataUpload, fileName: fileName, mimeType: mimeType)
      
    }) { (statusCode) in
      
      self.normalAlert(title: "Error", message: self.ErrorsDescription(result: statusCode as! Int), completionHandle: nil)
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
          
          let indexPath = IndexPath(row: 0, section: 0)
          
          DispatchQueue.main.async {
              self.filesTableView.insertRows(at: [indexPath], with: .automatic)
          }
          
        }
      case .failure(let encodingError):
        print(encodingError)
      }
    }
    
  }
  
  func getNextPageItemRequest(completionHandle : @escaping ()->Void) {
    
    Router.shared.getItemNextPage(url: self.nextHrefURL!, success: { (result) in
      
      let resultJSON = JSON(result!)
      
      let links = resultJSON["links"].dictionaryObject
      
      let nextURL = links?["next_url"] as? [String : String]
      
      if let nextURL = nextURL{
        
        self.nextHrefURL = nextURL["href"]
        
      }else{
        self.nextHrefURL = nil
      }
      
      for fileJson in resultJSON["data"].arrayValue{
        
        print(fileJson)
        
        let cloudFile = CloudFile(fileInformation: fileJson)
        
        self.files.append(cloudFile)
      }
      
      self.stopAnimating()
      
      completionHandle()
      
    }) { (statusCode) in
      self.normalAlert(title: "Error", message: self.ErrorsDescription(result: statusCode as! Int), completionHandle: nil)
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
      
      for fileJson in resultJSON["data"].arrayValue{
        
        print(fileJson)
        
        let cloudFile = CloudFile(fileInformation: fileJson)
        
        self.files.append(cloudFile)
      }
      
      self.stopAnimating()
      
      completionHandle()
      
    }) { (statusCode) in
      
      self.stopAnimating()
      
      self.normalAlert(title: "Error", message: self.ErrorsDescription(result: statusCode as! Int), completionHandle: nil)
      
    }
  }
  
}

extension CAFilesViewController : UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return files.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath) as! CAFileTableViewCell
    
    if files.count > 0 {
      cell.configureCell(file: files[indexPath.row])
    }
    
    return cell
  }
  
}

extension CAFilesViewController : UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    let detailVC = storyboard?.instantiateViewController(withIdentifier: "CADetailViewController") as! CADetailViewController
    
    detailVC.cloudFile = files[indexPath.row]
    detailVC.title = files[indexPath.row].name
    
    navigationController?.pushViewController(detailVC, animated: true)
    
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
    let file = files[indexPath.row]
    
    let moreAction = UITableViewRowAction(style: .default, title: "More") { (action, indexPath) in
      print("more action")
      
      self.openMore(file.name!, copyContent: file.content_url!, fileID : file.slug!, index: indexPath.row)
    }
    
    moreAction.backgroundColor = UIColor.lightGray
    
    let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
      print("delete action")
      
      self.deleteItem(id: file.slug!, indexPath: indexPath)
    }
    
    deleteAction.backgroundColor = UIColor.red
    
    return [deleteAction, moreAction]
    
  }
  
  func openMore(_ title : String, copyContent : String, fileID : String, index : Int) {
    
    let moreAlertController = UIAlertController(title: title, message: "", preferredStyle: .actionSheet)
    
    let copyAction = UIAlertAction(title: "Copy url", style: .default) { (_) in
      self.copyURL(content: copyContent)
    }
    
    let renameAction = UIAlertAction(title: "Rename", style: .default) { (_) in
      
      self.renameItem(nameItem: title, itemSlug: fileID, index: index)
      
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    moreAlertController.addAction(copyAction)
    moreAlertController.addAction(renameAction)
    moreAlertController.addAction(cancelAction)
    
    present(moreAlertController, animated: true, completion: nil)
    
  }
  
  // MARK: - More Action
  
  func copyURL(content : String){
    UIPasteboard.general.string = content
  }
  
  func renameItem(nameItem : String, itemSlug : String, index : Int) {
    
    var inputTextField : UITextField?
    
    let renameAlert = UIAlertController(title: "Rename", message: nameItem, preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
      
      guard let name = inputTextField?.text else {
        return
      }
      
      let parameter = ["long_link" : true,
                       "name": name as Any] as [String : Any]
      
      
      self.startIndicator(message: "Changing name")
      Router.shared.updateItemName(id: itemSlug, parameter: parameter, success: { (result) in
        
        let newItem = JSON(result!)
        
        let newFile = CloudFile(fileInformation: newItem)
        
        self.files.remove(at: index)
        
        self.files.insert(newFile, at: index)
        
        self.filesTableView.reloadData()
        
        self.stopAnimating()
        
      }, failed: { (statusCode) in
        
        self.stopAnimating()
        
        self.normalAlert(title: "Error", message: self.ErrorsDescription(result: statusCode as! Int), completionHandle: nil)
        
      })
      
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    renameAlert.addTextField { (textfield) in
      textfield.placeholder = "Input new name"
      inputTextField = textfield
    }
    
    renameAlert.addAction(saveAction)
    renameAlert.addAction(cancelAction)
    
    present(renameAlert, animated: true, completion: nil)
    
  }
  
  // MARK: - Delete Item
  func deleteItem(id : String, indexPath : IndexPath) {
    
    startIndicator(message: "Deleting item")
    Router.shared.deleteItem(id: id, success: { (response) in
      
      print("Success")
      
      self.files.remove(at: indexPath.row)
      
      self.filesTableView.deleteRows(at: [indexPath], with: .automatic)
      
      self.stopAnimating()
      
    }) { (statusCode) in
      
      print(statusCode as! Int)
      
      self.stopAnimating()
      
      self.normalAlert(title: "Error", message: self.ErrorsDescription(result: statusCode as! Int), completionHandle: nil)
    }
    
  }
  
}


extension CAFilesViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  
  func pickingImage() {
    imagePicker.allowsEditing = false
    imagePicker.sourceType = .savedPhotosAlbum
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

