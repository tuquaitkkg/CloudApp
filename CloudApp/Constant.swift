//
//  Constant.swift
//  CloudApp
//
//  Created by Vinh The on 1/3/17.
//  Copyright © 2017 Vinh The. All rights reserved.
//

import Foundation

//Admob Settings
//let keyAdmod = ""
//let keyBanner = ""
//let keyInterstitial = ""

let keyAdmod         = "ca-app-pub-9846141104180278~3039319479"
let keyBanner        = "ca-app-pub-9846141104180278/3898488469"
let keyInterstitial  = "ca-app-pub-9846141104180278/2660045520"

//ChartBoost Settings
let kChartBoostAppID = "583bb01f43150f089f8804ce"
let kChartBoostAppSignature = "58afcd0e69c3701bfb2df6eeaa7d1b7d06954988"

var kChartBoostTime = Date()

let kTime = 30

let APP_COLOR = UIColor(red: 90.0/255.0, green: 216.0/255.0, blue: 151.0/255.0, alpha: 1)

enum CloudURL {
  
  static let regisURL = "https://my.cl.ly/register"
  
}

enum ImageType : String{
  case image = "image"
  case zip = "archive"
  case text = "text"
  case audio = "audio"
  case video = "video"
  
  var resultImage : String {
    switch self {
    case .image:
      return "picture"
    case .zip:
      return "symbols"
    case .text:
      return "sheet"
    case .audio:
      return "audio"
    case .video:
      return "video"
    }
    
  }
		
}
