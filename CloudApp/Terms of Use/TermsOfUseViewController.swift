//
//  TermsOfUseViewController.swift
//  MCBackup
//
//  Created by Dream Digits on 3/27/18.
//  Copyright © 2018 Tien. All rights reserved.
//

import UIKit
import GoogleMobileAds
class TermsOfUseViewController: CABaseViewController {
    var bannerView: GADBannerView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = keyBanner
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        let string = """
        Terms of Use

        1. General

        Please read the Terms of Use carefully before installing or using our Services.

        By accessing and using the Services or downloading and installing the App you acknowledge that you have read these Terms of Use and our Privacy Policy which is incorporated herein by reference, as may be amended from time to time (collectively “the Terms”). These Terms shall govern any and all kind of use and features offered via the Services as may become available from to time to time. You agree to be bound by these Terms and to fully comply with them.
        
        If you do not agree to any of the Terms you should immediately stop using the Services and remove the App from your device. In this case, you may not download, copy, access or install the App or use any of our Services in any manner whatsoever.

        2. What do we do?
        ​
        Simpler offers you different contacts' management solutions such as: contacts backup & restore, merge duplicates, cleanup, group texting, group sharing & smart dialer, sync of your contact with your social network picture and additional solutions, features and enhancements as may become available by Simpler from time to time.

        Simpler also allow you to automatically identify incoming calls (“Caller ID”) and to perform a manual number search to easily find relevant contacts.

        We may also use your contacts and other data that we collect from other sources to enrich or app database with current and up to date contact information (e.g. emails, names, phone numbers).
                    
        3. Eligibility
        ​
        Any use or access by anyone under the age of 13 is prohibited. By accepting the Terms, you declare that you are at least 13 years or older and that you have the legal capacity to enter this agreement, including consent of your parent or guardian (where applicable) to use the Services.

        4. Creating an account
        ​
        In order to fully use the Services you must register and create an account. Creating your account can be done either by providing specific details (e.g. full name; email address; etc.), or by signing up via third-party online services, such as Google or Facebook. To learn more about our data collection practices and the specific types of data we may collect, use and disclose, please read our Privacy Policy which is incorporated in these Terms by reference.You agree to keep your account credential secret and secure. You also agree to inform us immediately of any unauthorized use of your account. By accepting the Terms, you declare that you are responsible for all activities taken under your account. Once you create an account, you will automatically join to our mailing list. You can choose to remove your email address from that mailing list by choosing the "unsubscribe" link at the bottom of any email communication we send to you.
        ​
        5. Payment and Fees
        
        We offer a version of limited Services for free. In order to enjoy the full scale of the Services that we offer, you may be required to pay the applicable fees assessed to your account. We maintain no refund or cancellation policy of any paid fees.

        6. Maintenance and Support
        
        We are aiming at providing our users with the best support for our Services and to constantly improve them. We created different tools to help our users, address frequently asked questions and additional technical and general support issues. Also, we test frequent updates, maintenance, error shooting and additional means in order to improve the Services.


        7. Intellectual Property and License
        
        Subject to your full compliance with the terms and conditions of these Terms and with applicable laws and regulation, we grant you a world-wide, limited non-exclusive, non-transferable, non-sub-licensable license to download and install a copy of the App and the right to use and access the Services on a mobile device that you own or control, in a format of an application, and to run such copy of the App and the Service solely for your own personal non-commercial purposes. Simpler reserves all rights in and to the App and the Services.Except as expressly stated herein, you may not copy, alter, adapt, modify, reproduce, distribute or commercially exploit any materials, including text, graphics, video, audio, software code, user interface design or logos, from this or any of our Services, without our prior written permission. You hereby warrant that you will not make any copies of, modify, adapt, disassemble, translate, decompile, distribute or otherwise transfer, rent, lease, loan, resell, sublicense or reverse engineer our Services or any part thereof. If you link from another website or applications to one or more of our Services, the website or the application, as well as the link itself, may not, without our prior written permission, suggest that we endorse, sponsor or are affiliated with any non-Company website, application, entity, service or product, and may not make use of any of our IP other than those contained within the text of the link.
        
        8. Privacy
        
        You acknowledge that to the extent you choose to use or access certain features of the Services you may be asked to submit or enable the transmission of certain personal information, which is required for the operability of our Services.
        
        At all times your information and Content will be treated in accordance with our Privacy Policy, which describes how we access, use, store and disclose your information and Content when you use the Services, and is incorporated in these Terms by reference. By accessing and using the Services, you agree and understand that we will use your information and Content as set forth in our Privacy Policy, and you allow us to do so.
        
        9. Your Representations and Undertakings
        ​
        You shall use our Services in complete accordance with the Terms, as amended from time to time, and only for the purposes stipulated in the Terms.
        ​
        You represent and warrant that all information and Content that you submit upon the sign-in process (including information submitted from your social network account, if applicable) and all other Content which is

        You grant the Company a worldwide, non-exclusive, perpetual, irrevocable, royalty-free, sub-licensable and transferable license to use and store your information and Content in connection with the Services.
        ​
        You acknowledge that you are responsible for any information or Content that you submit or transmit through the Services and any other communications options available by us, including your responsibility as to the privacy, legality, reliability, appropriateness, originality and copyright of any such information and Content, whether publicly posted or privately transmitted.

        10. Contact Information
        ​
        If You have any questions about these Terms, please contact us at cogangvigiadinh37@gmail.com
        """
        
        let lbName = UILabel()
        lbName.numberOfLines = 0
        lbName.textAlignment = .left
        lbName.sizeToFit()
        lbName.translatesAutoresizingMaskIntoConstraints = false
        lbName.text = string
        let size = CGSize(width: self.view.frame.width, height: 6.5*self.view.frame.height)
        scrollView.alwaysBounceVertical = true
        scrollView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        scrollView.contentSize = size
        scrollView.addSubview(lbName)
        let a = NSLayoutConstraint.init(item: lbName, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: self.view.frame.width - 400)
        let b = NSLayoutConstraint.init(item: lbName, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1.0, constant: 15.0)
        let c = NSLayoutConstraint.init(item: lbName, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1.0, constant: 10.0)
        self.view.addConstraints([a,b,c])
        
        
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
        // Dispose of any resources that can be recreated.
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
