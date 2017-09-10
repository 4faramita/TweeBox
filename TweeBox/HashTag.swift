//
//  HashTag.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/27.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class Hashtag: TweetEntity {
    
    var text: String
    
    override init(with json: JSON) {
        
        text = json["text"].stringValue
        
        super.init(with: json)
    }
}
