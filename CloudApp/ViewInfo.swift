//
//  ViewInfo.swift
//  CloudApp
//
//  Created by DAO VAN UOC on 6/13/18.
//  Copyright © 2018 Vinh The. All rights reserved.
//

import UIKit

class ViewInfo: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    
    
    @IBInspectable public var title:String = "" {
        didSet{
            self.lbTitle.text = title
        }
    }
    
    @IBInspectable public var fontsize:Float = 13 {
        didSet{
            self.lbTitle.font = UIFont.systemFont(ofSize: CGFloat(fontsize))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    func setTitle(title:String)->Void{
       
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
//        self.lbTitle.text = "123"
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: "ViewInfo", bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
}
