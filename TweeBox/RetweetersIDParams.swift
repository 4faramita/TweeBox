//
//  RetweetersIDParams.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/22.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

class RetweetersIDParams {
    
    public var id: String
    public var cursor: String? = "-1"
    
//    stringify_ids
    
    init(id: String) {
        self.id = id
    }
    
    public func getParams() -> [String: String] {
        
        var params = [String: String]()
        
        params["id"] = id

        params["cursor"] = cursor
                
        params["stringify_ids"] = "true"
        
        return params
    }

}
