//
//  RetweeterID.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/22.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON


class RetweeterID {
    
//    private var userIDList: [String]?
    
    public var nextCursor = "-1"
    public var previousCursor = "-1"
    // cursor == "0" indicates the corresponding direction is at the end
    
    public var fetchOlder = true
    
    public var retweetersIDParams: RetweetersIDParams
    public var resourceURL: (String, String)

    init(resourceURL: (String, String), retweetersIDParams: RetweetersIDParams, fetchOlder: Bool?, nextCursor: String?, previousCursor: String?) {
        
        self.resourceURL = resourceURL
        
        self.retweetersIDParams = retweetersIDParams
        
        if let fetchOlder = fetchOlder {
            self.fetchOlder = fetchOlder
        }
        
        if let nextCursor = nextCursor {
            self.nextCursor = nextCursor
        }
        
        if let previousCursor = previousCursor {
            self.previousCursor = previousCursor
        }
    }
    
    
    public func fetchData(_ handler: @escaping (String, String, [String]) -> Void) {
        
        if Constants.selfID != "-1" {
            
            if fetchOlder, previousCursor != "-1" {
                retweetersIDParams.cursor = previousCursor
            }
            
            if !fetchOlder, nextCursor != "-1" {
                retweetersIDParams.cursor = nextCursor
            }
            
            let client = RESTfulClient(resource: resourceURL, params: retweetersIDParams.getParams())
            
            client.getData() { data in
                let json = JSON(data: data)
                
                self.nextCursor = json["next_cursor_str"].stringValue
                self.previousCursor = json["previous_cursor_str"].stringValue
                
                let idList = json["ids"].arrayValue.map({ $0.stringValue })
                
                handler(self.nextCursor, self.previousCursor, idList)
            }
        }
    }

}
