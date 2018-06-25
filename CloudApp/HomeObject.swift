//
//  HomeObject.swift
//  CloudApp
//
//  Created by DAO VAN UOC on 6/14/18.
//  Copyright © 2018 Vinh The. All rights reserved.
//

import UIKit

class HomeObject: NSObject {

    var imageType: String!
    var title: String!
    
    init(title:String, image:String) {
        super.init()
        self.title = title
        self.imageType = image
    }
    
}
