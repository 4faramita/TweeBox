//
//  RetweetersIDParams.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/22.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

class RetweetersIDParams: ParamsWithCursorProtocol {
    
    public var id: String
    public var cursor: String? = "-1"
    
//    stringify_ids
    
    init(id: String, cursor: String?) {
        self.id = id
        if let cursor = cursor {
            self.cursor = cursor
        }
    }
    
    public func getParams() -> [String: Any] {
        
        var params = [String: String]()
        
        params["id"] = id
        
        if let cursor = cursor, cursor != "-1" {
            params["cursor"] = cursor
        }
        
                
        params["stringify_ids"] = "true"
        
        return params
    }

}
