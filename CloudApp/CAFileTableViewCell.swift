//
//  CAFileTableViewCell.swift
//  CloudApp
//
//  Created by Vinh The on 1/5/17.
//  Copyright © 2017 Vinh The. All rights reserved.
//

import UIKit

class CAFileTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var createDate: UILabel!
  
  @IBOutlet weak var typeImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    accessoryType = .disclosureIndicator
  }
		
  func configureCell(file : CloudFile) {
    
    nameLabel.text = file.name
    createDate.text = file.updated_at
    
    configureImageType(imageType: file.item_type!)
    
  }
  
  func configureImageType(imageType : String) {
    
    switch imageType {
    case ImageType.image.rawValue:
      typeImageView.image = UIImage(named: ImageType.image.resultImage)
    case ImageType.text.rawValue:
      typeImageView.image = UIImage(named: ImageType.text.resultImage)
    case ImageType.zip.rawValue:
      typeImageView.image = UIImage(named: ImageType.zip.resultImage)
    case ImageType.audio.rawValue:
      typeImageView.image = UIImage(named: ImageType.audio.resultImage)
    case ImageType.video.rawValue:
      typeImageView.image = UIImage(named: ImageType.video.resultImage)
    default:
      typeImageView.image = #imageLiteral(resourceName: "other.png")
    }
    
  }
}
