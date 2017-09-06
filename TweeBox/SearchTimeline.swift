//
//  SearchTimeline.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/26.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchTimeline: Timeline {
    
    override func appendTweet(from json: JSON) {
        
        for (_, tweetJSON) in json["statuses"] {
            if tweetJSON.null == nil {
                let tweet = Tweet(with: tweetJSON)
                addToTimeline(tweet)
            }
        }
    }

    func addToTimeline(_ tweet: Tweet) {
        self.timeline.append(tweet)
    }
}
