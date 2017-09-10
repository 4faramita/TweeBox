//
//  Mention.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/27.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON


class Mention: TweetEntity {
//    var id: String
//    var screenName: String
//    var name: String
    
    override init(with json: JSON) {
        
        id = json["id_str"].stringValue
        screenName = json["screen_name"].stringValue
        name = json["name"].stringValue
        
        super.init(with: json)
    }
}
