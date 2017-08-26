//
//  UsersSearchParams.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/26.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

class UsersSearchParams: ParamsProtocol {
    
    public var query: String
    
    public var page: Int {
        // Specifies the page of results to retrieve.
        return Int(Int(Constants.tweetLimitPerRefresh)! / 20)
    }
    
    public var count = 20
    // The number of potential user results to retrieve per page. 
    // This value has a maximum of 20.
    
    public var includeEntities = true
    
    
    init(query: String) {
        self.query = query
    }
    
    func getParams() -> [String : Any] {
        
        var params = [String: String]()
        
        params["q"] = query
        
        params["page"] = "\(page)"
        
        params["count"] = "\(count)"
        
        params["include_entities"] = includeEntities.description
        
        return params

    }
}
