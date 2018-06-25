//
//  S3.swift
//  CloudApp
//
//  Created by Vinh The on 1/7/17.
//  Copyright © 2017 Vinh The. All rights reserved.
//

import Foundation
import SwiftyJSON

class S3 {
  
  let slug: String
  let name: String
  let url: String
  let uploads_remaining: Int
  let max_upload_size: Double
  var s3Parameter = [String:String]()
  
  init(s3Information : JSON) {
    slug = s3Information["slug"].stringValue
    name = s3Information["name"].stringValue
    url = s3Information["url"].stringValue
    uploads_remaining = s3Information["uploads_remaining"].intValue
    max_upload_size = s3Information["max_upload_size"].doubleValue
    s3Parameter = s3Information["s3"].dictionaryObject as! [String : String] 
  }
  
}

