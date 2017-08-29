//
//  SpamUserParams.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/29.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

class SpamUserParams: SimpleUserParams {
    
    var performBlock = true
    
    init(userID: String?, screenName: String?, performBlock: Bool?) {
        
        if let performBlock = performBlock {
            self.performBlock = performBlock
        }
        
        super.init(userID: userID, screenName: screenName)
        
    }
    
    override func getParams() -> [String : Any] {
        
        var params = [String: String]()
        
        if userID != nil {
            params["user_id"] = userID
        } else if screenName != nil {
            params["screen_name"] = screenName
        }
        
        params["perform_block"] = performBlock.description
        
        return params
    }

}
