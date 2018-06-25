
//
//  HomeCell.swift
//  CloudApp
//
//  Created by DAO VAN UOC on 6/14/18.
//  Copyright © 2018 Vinh The. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var lbType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configCell(object:HomeObject) -> Void {
        self.lbType.text = object.title
        self.imgType.image = UIImage.init(named: object.imageType)
    }
    
}
