//
//  PasscodeViewController.swift
//  MCBackup
//
//  Created by Apple on 4/5/18.
//  Copyright © 2018 Tien. All rights reserved.
//

import UIKit
import LocalAuthentication

class PasscodeViewController: CABaseViewController {
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var lb4: UILabel!
    @IBOutlet weak var lb5: UILabel!
    @IBOutlet weak var lb6: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var isMain = false
    @IBOutlet weak var layoutIpad: NSLayoutConstraint!
    let defaults = UserDefaults.standard
    var arrPass = [String]()
    var arrlb = [UILabel]()
    var a = 5
    var n = 0
    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isMain == true{
            btnBack.isHidden = true
        }else{
            btnBack.isHidden = false
        }
        collectionView.register(UINib(nibName: "PasscodeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "celll")
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        arrlb.append(lb1)
        arrlb.append(lb2)
        arrlb.append(lb3)
        arrlb.append(lb4)
        arrlb.append(lb5)
        arrlb.append(lb6)

    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PasscodeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celll", for: indexPath) as! PasscodeCollectionViewCell
        cell.lbNumber.text = String(indexPath.row + 1)
        cell.imageView.image = UIImage(named: "ic_Number")
        cell.imageView.contentMode = .scaleToFill
        if indexPath.row == 9 {
            cell.viewbt.isHidden = true
            cell.imgBG.image = UIImage(named: "ic_Number")
            cell.imageView.image = UIImage(named: "ic_fingerprint")
             cell.imageView.contentMode = .center
        } else if indexPath.row == 10 {
            cell.lbNumber.text = "0"
        } else if indexPath.row == 11 {
            cell.viewbt.isHidden = true
            cell.imgBG.image = UIImage(named: "ic_Number")
            cell.imageView.image = UIImage(named: "ic_DeletePasscode")
             cell.imageView.contentMode = .center
        }
        
//        switch (deviceIdiom) {
//            
//        case .pad:
//            cell.viewbt.layer.cornerRadius = 75
//        case .phone:
//            cell.viewbt.layer.cornerRadius = (self.collectionView.bounds.width - 50)/6
//        default:
//            print("Unspecified UI idiom")
//        }
        //cell.viewbt.layer.cornerRadius = (self.collectionView.bounds.width - 50)/6
        //cell.viewbt.layer.cornerRadius = 125
        cell.viewbt.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 9 {
            let alertView = UIAlertController(title: "Password", message: "Please, Touch ID", preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "Yes", style: .default, handler: {
                action in
                self.authenticateUser()
            })
            alertView.addAction(actionYes)
            self.present(alertView, animated: true, completion: nil)
        } else if indexPath.row == 10 {
            if n >= 6  {
                print("ok")
                n = 5
            } else {
                arrlb[n].text = "0"
                if n == 5 {
                    var result = ""
                    if defaults.string(forKey: "pass") == nil {
                        for data in arrlb {
                            print(data.text!)
                            result = result + data.text!
                        }
                        defaults.set(result, forKey: "pass")
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        for data in arrlb {
                            result = result + data.text!
                        }
                        if result == defaults.string(forKey: "pass"){
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            let alertView = UIAlertController(title: "Password incorrect", message: "Please, enter password", preferredStyle: .alert)
                            let actionYes = UIAlertAction(title: "Yes", style: .default, handler: nil)
                            alertView.addAction(actionYes)
                            self.present(alertView, animated: true, completion: nil)
                        }
                    }
                }
            }
            n = n + 1
            
        } else if indexPath.row == 11 {
             n = n - 1
            if n < 0 {
                n = 0
            } else {
                arrlb[n].text = ""
            }
        } else {

            if n >= 6  {
                print("ok")
                n = 5
            } else{
               arrlb[n].text = String(indexPath.row + 1)
                if n == 5 {
                    var result = ""
                    if defaults.string(forKey: "pass") == nil {
                        for data in arrlb {
                            result = result + data.text!
                        }
                        defaults.set(result, forKey: "pass")
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        for data in arrlb {
                            result = result + data.text!
                        }
                        if result == defaults.string(forKey: "pass"){
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            let alertView = UIAlertController(title: "Password incorrect", message: "Please, enter password", preferredStyle: .alert)
                            let actionYes = UIAlertAction(title: "Yes", style: .default, handler: nil)
                            alertView.addAction(actionYes)
                            self.present(alertView, animated: true, completion: nil)
                        }
                    }
                }
            }
            n = n + 1
        }
    }
    
    // touch id
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.runSecretCode()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func runSecretCode() {
      self.dismiss(animated: true, completion: nil)
    }

}

extension PasscodeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize!
        switch (deviceIdiom) {
            
        case .pad:
            print("iPad style UI")
            size = CGSize(width: 150, height: 150)
        case .phone:
            print("iPhone and iPod touch style UI")
            size = CGSize(width: (self.collectionView.bounds.width - 50)/3, height: (self.collectionView.bounds.height - 50)/4)
        default:
            print("Unspecified UI idiom")
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // 10
        var a: CGFloat = 0.0
        switch (deviceIdiom) {
            
        case .pad:
            a = 40.0
        case .phone:
            a = 10
        default:
            print("Unspecified UI idiom")
        }
        return a
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        var a: CGFloat = 0.0
        switch (deviceIdiom) {
            
        case .pad:
            a = 80.0
        case .phone:
            a = 1.0
        default:
            print("Unspecified UI idiom")
        }
        return a
    }
}
