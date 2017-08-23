//
//  MentionTimelineParams.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/23.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

class MentionTimelineParams: TimelineParams {
    
    init(sinceID: String? = nil, maxID: String? = nil) {
        
        super.init(sinceID: sinceID, maxID: maxID, excludeReplies: nil, includeRetweets: nil)
        
        resourceURL = ResourceURL.statuses_mentions_timeline
    }

}
