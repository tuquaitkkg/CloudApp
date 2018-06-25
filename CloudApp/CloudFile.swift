//
//  CloudFile.swift
//  CloudApp
//
//  Created by Vinh The on 1/3/17.
//  Copyright © 2017 Vinh The. All rights reserved.
//

import Foundation
import SwiftyJSON

class CloudFile{
  let id: String?
  let slug: String?
  let name: String?
  let created_at: String?
  let updated_at: String?
  let file_private: Bool?
  let item_type: String?
  let view_counter: String?
  let content_url: String?
  let source: String?
  let thumbnailImage: String?
  
  init(fileInformation : JSON) {
    let strID = fileInformation["id"].int64
    id = String(format: "%d", strID!)
    slug = fileInformation["slug"].string
    name = fileInformation["name"].string
    created_at = fileInformation["created_at"].string
    updated_at = fileInformation["updated_at"].string
    file_private = fileInformation["private"].bool
    item_type = fileInformation["item_type"].string
    view_counter = fileInformation["view_counter"].string
    content_url = fileInformation["content_url"].string
    source = fileInformation["source"].string
    thumbnailImage = fileInformation["thumbnail_url"].string
    
  }
}
