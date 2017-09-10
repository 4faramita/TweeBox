//
//  SearchTimeline.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/26.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class SearchTimeline: Timeline {
        
    override func appendTweet(with json: JSON) {
        
        let innerJSON = json["statuses"]
        
        super.appendTweet(with: innerJSON)
    }
}
