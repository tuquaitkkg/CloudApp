//
//  SettingViewController.swift
//  MCBackup
//
//  Created by Apple on 3/25/18.
//  Copyright © 2018 Tien. All rights reserved.
//

import UIKit
import GoogleMobileAds
import MessageUI
import Social

class SettingViewController: CABaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var bannerView: GADBannerView!
    let picker : MFMailComposeViewController = MFMailComposeViewController()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.delegate =  self
        tableView.dataSource = self
        
        title = "Setting"
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = keyBanner
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        picker.mailComposeDelegate = self
        picker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    func shareMail()
    {
        let mailClass : AnyClass? = NSClassFromString("MFMailComposeViewController")
        if mailClass != nil
        {
            if MFMailComposeViewController.canSendMail()
            {
                displayComposerSheet()
            }
            else
            {
                launchMailAppOnDevice()
            }
        }
        else
        {
            launchMailAppOnDevice()
        }
    }
    
    func launchMailAppOnDevice()
    {
        
        let alertView = UIAlertController(title: "", message: "Please, set up mail. Setting -> Accounts & Passwords -> Add Acount.", preferredStyle: .alert)
        
        let actionYes = UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        exit(1)
                    })
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        })
        alertView.addAction(actionYes)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func displayComposerSheet()
    {
        picker.setSubject("Test")
        picker.setToRecipients(["trancaocuong@gmail.com"])
        present(picker, animated: true, completion: nil)
        
    }
    
    @objc func btswitch(sender: UISwitch) {
        if sender.isOn {
            defaults.set(1, forKey: "switch")

//            if defaults.string(forKey: "pass") == nil {
                self.present(PasscodeViewController(), animated: true, completion: {
                    let alertView = UIAlertController(title: "Password", message: "Please, register password", preferredStyle: .alert)
                    let actionYes = UIAlertAction(title: "Yes", style: .default, handler: nil)
                    alertView.addAction(actionYes)
                    self.present(alertView, animated: true, completion: nil)
                })
//            }
        }else {
            defaults.set(0, forKey: "switch")

        }
    }
    
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingTableViewCell
        if indexPath.row == 0 {
            cell.lbNameSetting.text = "Change Passcode"
        } else if indexPath.row == 1 {
            cell.lbNameSetting.text = "Privacy Policy"
        } else if indexPath.row == 2  {
            cell.lbNameSetting.text = "Terms of Use"
        } else if indexPath.row == 3 {
            cell.lbNameSetting.text = "Suport"
        } else if indexPath.row == 4 {
             cell.lbNameSetting.text = "Share this app"
        } else {
            cell.lbNameSetting.text = "Logout"
        }
        cell.switchPasscode.addTarget(self, action: #selector(btswitch), for: .touchUpInside)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            navigationController?.pushViewController(TermsOfUseViewController(), animated: true)
        } else if indexPath.row == 1 {
            navigationController?.pushViewController(PrivacyPolicyViewController(), animated: true)
        } else if indexPath.row == 3 {
            self.shareMail()
        } else if indexPath.row == 0 {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let passcodeVC = storyboard.instantiateViewController(withIdentifier: "PasscodeViewController") as! PasscodeViewController
            passcodeVC.typeView = 1
            present(passcodeVC, animated: true, completion: nil)
        } else if indexPath.row == 5 {
           
            let alertView = UIAlertController(title: "Alert", message: "Do you want logout this app?", preferredStyle: .alert)
           let actionYes  = UIAlertAction(title: "Yes", style: .default) { (action) in
             let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CALoginViewController") as! CALoginViewController
            UserDefaults.standard.removeObject(forKey: "UserInformation")
            UserDefaults.standard.set(0, forKey: "switch")
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
                 appdelegate.window!.rootViewController = loginVC
            
            }
            let actionNO = UIAlertAction(title: "No", style: .default, handler: nil)
            alertView.addAction(actionYes)
            alertView.addAction(actionNO)
            self.present(alertView, animated: true, completion: nil)
        } else {
            let activityVC = UIActivityViewController(activityItems: [""], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view : UIView = {
            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 5.0 , height: 5.0))
            view.backgroundColor = UIColor.white
            return view
        }()
        
        return view
    }
    
}

extension SettingViewController: MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            print("Mail cancelled")
          
            break
        case .saved:
            print("Mail saved")
            break
        case .sent:
            print("Mail sent")
           
            break
        case .failed:
            
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
