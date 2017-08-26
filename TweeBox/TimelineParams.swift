//
//  TimelineParams.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/9.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

class TimelineParams: ParamsWithBoundsProtocol {
    
    public var sinceID: String?
    
    //    count: no need to define here
    
    public var maxID: String?
    
    //    trimUser
    
    public var excludeReplies = false
    
    public var includeRetweets = true
    
    public var resourceURL = ResourceURL.search_tweets
    

    init(sinceID: String? = nil, maxID: String? = nil, excludeReplies: Bool?, includeRetweets: Bool?) {
        
        self.sinceID = sinceID
        self.maxID = maxID
        if let excludeReplies = excludeReplies {
            self.excludeReplies = excludeReplies
        }
        if let includeRetweets = includeRetweets {
            self.includeRetweets = includeRetweets
        }
    }
    
    public func getParams() -> [String: Any] {
        
        var params = [String: String]()
        
        params["count"] = Constants.tweetLimitPerRefresh
        
        if sinceID != nil {
            params["since_id"] = sinceID
        }
        
        if maxID != nil {
            params["max_id"] = maxID
        }
        
        if excludeReplies {
            params["exclude_replies"] = "true"
        }
        
        if !includeRetweets {
            params["include_rts"] = "false"
        }
        
        return params
    }
}
