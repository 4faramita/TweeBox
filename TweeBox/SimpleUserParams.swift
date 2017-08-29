//
//  SimpleUserParams.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/29.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

class SimpleUserParams: UserParams {
    
//    public var follow: Bool
    // Enable notifications for the target user.
    
    override func getParams() -> [String : Any] {
        
        var params = [String: String]()
        
        if userID != nil {
            params["user_id"] = userID
        } else if screenName != nil {
            params["screen_name"] = screenName
        }
        
        return params
    }
}
