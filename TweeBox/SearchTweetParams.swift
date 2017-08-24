//
//  SearchTweetParams.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/24.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

class SearchTweetParams: ParamsWithBounds {
    
    public var query: String  // qd
    // A UTF-8, URL-encoded search query of 500 characters maximum, including operators. 

//    public var geocode
//    public var lang
//    public var locale
    
    public var resultType: SearchResultType
    
    public var count = Constants.tweetLimitPerRefresh
    
    public var until: Date?
    /*
     Returns tweets created before the given date. 
     Date should be formatted as YYYY-MM-DD. 
     Keep in mind that the search index has a 7-day limit. 
     In other words, no tweets will be found for a date older than one week.
     */
    
    public var sinceID: String?
    public var maxID: String?
    
    public var includeEntities = true
    
    public var resourceURL: (String, String)!
    
    
    init(
        query: String,
        resultType: SearchResultType,
        until: Date?,
        sinceID: String?,
        maxID: String?,
        includeEntities: Bool?,
        resourceURL: (String, String)
    ) {
        self.query = query
        self.resultType = resultType
        
        if let until = until {
            self.until = until
        }
        if let sinceID = sinceID {
            self.sinceID = sinceID
        }
        if let maxID = maxID {
            self.maxID = maxID
        }
        if let includeEntities = includeEntities {
            self.includeEntities = includeEntities
        }
        
        self.resourceURL = resourceURL
    }
    
    public func getParams() -> [String: Any] {
        
        var params = [String: String]()
        
        params["q"] = query
        
        params["result_type"] = resultType.rawValue
        
        params["count"] = count
        
//        if let until = until {
            // do things about until
//        }
        
        if let sinceID = sinceID {
            params["since_id"] = sinceID
        }
        
        if let maxID = maxID {
            params["max_id"] = maxID
        }
        
        params["include_entities"] = includeEntities.description
        
        return params

    }
}
