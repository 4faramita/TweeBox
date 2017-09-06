//
//  ReplyTimeline.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/24.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON

class ReplyTimeline: SearchTimeline {
    
    public var mainTweetID: String
    
    init(maxID: String?, sinceID: String?, fetchNewer: Bool = true, resourceURL: (String, String), timelineParams: ParamsWithBoundsProtocol, mainTweetID: String) {
        
        self.mainTweetID = mainTweetID
        
        super.init(maxID: maxID, sinceID: sinceID, resourceURL: resourceURL, params: timelineParams)
    }

    
    override func addToTimeline(_ tweet: Tweet) {

        if let repliedID = tweet.inReplyToStatusID, repliedID == mainTweetID {
            self.timeline.append(tweet)
        }
    }
}
