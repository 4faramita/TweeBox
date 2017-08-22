//
//  MultiUserParams.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/23.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

class MultiUserParams {
    
    public var userID: [String]?
    
    public var screenName: [String]?
    
    public var includeEntities = false
    
    init(userID: [String]?, screenName: [String]?) {
        self.userID = userID
        self.screenName = screenName
    }
    
    
    public func getParams() -> [String: Any] {
        
        var params = [String: Any]()
        
        guard (userID != nil || screenName != nil) else {
            return params
        }
        
        if userID != nil {
            params["user_id"] = userID
        } else {
            params["screen_name"] = screenName
        }
        
        params["include_entities"] = includeEntities.description
        
        return params
    }

}
