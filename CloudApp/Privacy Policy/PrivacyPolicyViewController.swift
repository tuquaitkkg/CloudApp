//
//  PrivacyPolicyViewController.swift
//  MCBackup
//
//  Created by Apple on 3/28/18.
//  Copyright © 2018 Tien. All rights reserved.
//

import UIKit
import GoogleMobileAds
class PrivacyPolicyViewController: CABaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = keyBanner
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        let string = """
        Privacy Policy:

        This Privacy Policy governs the manner in which rebirthapps collects, uses, maintains and discloses information collected from users. This privacy policy applies to the Site and is incorporated therein by references.

        Personal identification information

        We may collect personal identification information from Users in a variety of ways, including, but not limited to, when Users visit our site, fill out a form, and in connection with other activities, services, features or resources we make available on our Site. Users may be asked for, as appropriate, social security number. Users may, however, visit our Site anonymously. We will collect personal identification information from Users only if they voluntarily submit such information to us. Users can always refuse to supply personally identification information, except that it may prevent them from engaging in certain Site related activities.

        Non-personal identification information

        We may collect non-personal identification information about Users whenever they interact with our Site. Non-personal identification information may include the browser name, the type of computer and technical information about Users means of connection to our Site, such as the operating system and the Internet service providers utilized and other similar information.

        Web browser cookies

        Our Site may use "cookies" to enhance User experience. User's web browser places cookies on their hard drive for record-keeping purposes and sometimes to track information about them. User may choose to set their web browser to refuse cookies, or to alert you when cookies are being sent. If they do so, note that some parts of the Site may not function properly.

        How we use collected information

        app may collect and use Users personal information for the following purposes:
        - To improve customer service
        Information you provide helps us respond to your customer service requests and support needs more efficiently.
        - To send periodic emails
        We may use the email address to respond to their inquiries, questions, and/or other requests.

        How we protect your information

        We adopt appropriate data collection, storage and processing practices and security measures to protect against unauthorized access, alteration, disclosure or destruction of your personal information, username, password, transaction information and data stored on our Site.

        Sharing your personal information

        We do not sell, trade, or rent Users personal identification information to others. We may share generic aggregated demographic information not linked to any personal identification information regarding visitors and users with our business partners, trusted affiliates and advertisers for the purposes outlined above.

        Compliance with children's online privacy protection act

        Protecting the privacy of the very young is especially important. For that reason, we never collect or maintain information at our Site from those we actually know are under 13, and no part of our website is structured to attract anyone under 13.

        Changes to this privacy policy

        app has the discretion to update this privacy policy at any time. When we do, we will post a notification on the main page of our Site. We encourage Users to frequently check this page for any changes to stay informed about how we are helping to protect the personal information we collect. You acknowledge and agree that it is your responsibility to review this privacy policy periodically and become aware of modifications.

        Your acceptance of these terms

        By using this Site, you signify your acceptance of this policy and terms of service. If you do not agree to this policy, please do not use our Site. Your continued use of the Site following the posting of changes to this policy will be deemed your acceptance of those changes.

        Contacting us

        If you have any questions about this Privacy Policy, the practices of this site, or your dealings with this site, please contact us at:
        cogangvigiadinh37@gmail.com
        """
        
        let lbName = UILabel()
        lbName.numberOfLines = 0
        lbName.textAlignment = .left
        lbName.sizeToFit()
        lbName.translatesAutoresizingMaskIntoConstraints = false
        lbName.text = string
        let size = CGSize(width: self.view.frame.width, height: 4*self.view.frame.height)
        scrollView.alwaysBounceVertical = true
        scrollView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        scrollView.contentSize = size
        scrollView.addSubview(lbName)
        let a = NSLayoutConstraint.init(item: lbName, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: self.view.frame.width - 400)
        let b = NSLayoutConstraint.init(item: lbName, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1.0, constant: 15.0)
        let c = NSLayoutConstraint.init(item: lbName, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1.0, constant: 10.0)
        self.view.addConstraints([a,b,c])
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
