//
//  CALoginViewController.swift
//  CloudApp
//
//  Created by Vinh The on 1/3/17.
//  Copyright © 2017 Vinh The. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView

class CALoginViewController: CABaseViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var loginButton: UIButton!
  
  @IBOutlet weak var signUpButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    settingUpLoginView()
    emailTextField.text = "nguyenthithuthao251103@gmail.com"
    passwordTextField.text = "Conyeume1997"
  }
  
  func settingUpLoginView() {
    
    emailTextField.layer.cornerRadius = 22
    passwordTextField.layer.cornerRadius = 22
    loginButton.layer.cornerRadius = 22
    
  }
  
  @IBAction func loginAction(_ sender: Any) {
    
    if emailTextField.text != "" && passwordTextField.text != "" {
      
      startIndicator(message: "Login in...")
      
      Router.shared.authenticate(email: emailTextField.text!, password: passwordTextField.text!, success: { (statusCode) in
        
        guard let statusCode = statusCode else{
          return
        }
        
        let result = statusCode as! Int
        
        if result == ConnectionError.success.rawValue{
          
          let userInformation = ["email":self.emailTextField.text!, "password":self.passwordTextField.text!]
          
          UserDefaults.standard.set(userInformation, forKey: "UserInformation")
          
//          let fileVC = self.storyboard?.instantiateViewController(withIdentifier: "CAFilesViewController") as! CAFilesViewController
//
//          fileVC.title = "Files"
            let home = HomeVC(nibName: "HomeVC", bundle: nil)
            home.title = "HOME"
          let fileNav = UINavigationController(rootViewController: home)
          
          self.stopAnimating()
          
          self.present(fileNav, animated: true, completion: nil)
          
          
        }else{
          self.stopAnimating()
          
          self.normalAlert(title: "Error", message: self.ErrorsDescription(result: result), completionHandle: nil)
          
        }
        
      })
      
    }else{
      
      self.normalAlert(title: "Warning", message: "You need input emaill & password", completionHandle: nil)
      
      
    }
    
  }
  
  
  @IBAction func signUpAction(_ sender: Any) {
    
    UIApplication.shared.openURL(URL(string: CloudURL.regisURL)!)
    
  }

}


