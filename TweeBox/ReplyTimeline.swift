//
//  ReplyTimeline.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/24.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON

class ReplyTimeline: Timeline {
    
    public var mainTweetID: String
    
    init(maxID: String?, sinceID: String?, fetchNewer: Bool = true, resourceURL: (String, String), timelineParams: ParamsWithBounds, mainTweetID: String) {
        
        self.mainTweetID = mainTweetID
        
        super.init(maxID: maxID, sinceID: sinceID, resourceURL: resourceURL, timelineParams: timelineParams)
    }

    
    override func appendTweet(from json: JSON) {
        
        for (_, tweetJSON) in json["statuses"] {
            if tweetJSON.null == nil {
                let tweet = Tweet(with: tweetJSON)
                if let repliedID = tweet.inReplyToStatusID, repliedID == mainTweetID {
                    self.timeline.append(tweet)  // mem cycle?
                }
            }
        }
    }
}
