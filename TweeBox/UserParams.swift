//
//  UserParams.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/20.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

class UserParams {
    
    public var userID: String?
    
    public var screenName: String?
    
    public var includeEntities = true
    
    init(userID: String?, screenName: String?) {
        self.userID = userID
        self.screenName = screenName
    }
    
    
    public func getParams() -> [String: String] {
        
        var params = [String: String]()
        
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
