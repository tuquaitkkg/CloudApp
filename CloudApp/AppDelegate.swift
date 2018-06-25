//
//  AppDelegate.swift
//  CloudApp
//
//  Created by Vinh The on 1/3/17.
//  Copyright © 2017 Vinh The. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        // Admob
        GADMobileAds.configure(withApplicationID: keyAdmod)
        
        checkingAuthentication()
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func setupMainView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let _ = UserDefaults.standard.dictionary(forKey: "UserInformation") {
            let home = HomeVC(nibName: "HomeVC", bundle: nil)
            home.title = "HOME"
            let filesNav = UINavigationController(rootViewController: home)
            window?.rootViewController = filesNav
        }else{
            let loginVC = storyboard.instantiateViewController(withIdentifier: "CALoginViewController") as! CALoginViewController
            window?.rootViewController = loginVC
        }
        window?.makeKeyAndVisible()
    }
    
    public func checkingAuthentication() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let passcodeVC = storyboard.instantiateViewController(withIdentifier: "PasscodeViewController") as? PasscodeViewController
        passcodeVC?.typeView = 0
        self.window?.rootViewController = passcodeVC
    }
    
}

