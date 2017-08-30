//
//  TweetPostParams.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/30.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

class TweetPostParams: ParamsProtocol {
    
    var text: String  // status
    
    var inReplyToStatusID: String?
    
    var possiblySensitive: Bool
    
//    lat
//    long
//    place_id
//    display_coordinates
    
    var trimUser = false
    
    var mediaIDs: String? // [String]()
    
    var enableDMCommands = false
    
    var failDMCommands = false
    
    
    init(text: String, inReplyToStatusID: String?, possiblySensitive: Bool, mediaIDs: String?) {
        self.text = text
        
        if let inReplyToStatusID = inReplyToStatusID {
            self.inReplyToStatusID = inReplyToStatusID
        }
        
        self.possiblySensitive = possiblySensitive
        
        if let mediaIDs = mediaIDs {
            self.mediaIDs = mediaIDs
        }
    }
    
    func getParams() -> [String : Any] {
        
        var params = [String : Any]()
        
        params["status"] = text
        
        if let inReplyToStatusID = inReplyToStatusID {
            params["in_reply_to_status_id"] = inReplyToStatusID
        }
        
        params["possibly_sensitive"] = possiblySensitive.description
        
        if let mediaIDs = mediaIDs {
            params["media_ids"] = mediaIDs
        }
        
        params["enable_dm_commands"] = enableDMCommands.description
        
        params["fail_dm_commands"] = failDMCommands.description
        
        return params
    }
}
