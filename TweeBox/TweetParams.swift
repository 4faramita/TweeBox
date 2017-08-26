//
//  TweetParams.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/21.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

class TweetParams: ParamsProtocol {
    
    public var tweetID: String?
    
    public var trimUser = false
    
    public var includeMyRetweet = true
    
    public var includeEntities = true
    
    public var includeExtAltText = true
    
    
    init(of tweetID: String) { self.tweetID = tweetID }
    
    
    public func getParams() -> [String: Any] {
        
        var params = [String: String]()
        
        guard tweetID != nil else { return params }
        
        params["id"] = tweetID!
        
        if trimUser {
            params["trim_user"] = "true"
        }
        
        if !includeMyRetweet {
            params["include_my_retweet"] = "false"
        }
        
        if !includeEntities {
            params["include_entities"] = "false"
        }
        
        if !includeExtAltText {
            params["include_ext_alt_text"] = "false"
        }
        
        return params
    }
}
