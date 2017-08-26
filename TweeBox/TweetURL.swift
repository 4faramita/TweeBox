//
//  TweetURL.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/27.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON

class TweetURL: TweetEntity {
    
    var url: URL?
    // The t.co URL that was extracted from the Tweet text
    var displayURL: URL?
    var expandedURL: URL?
    // The resolved URL
    
    override init(with json: JSON) {
        
        url = URL(string: json["url"].stringValue)
        displayURL = URL(string: json["display_url"].stringValue)
        expandedURL = URL(string: json["expanded_url"].stringValue)
        
        super.init(with: json)
    }
}
