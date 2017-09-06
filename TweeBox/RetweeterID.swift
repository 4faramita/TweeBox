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
    
    public var params: RetweetersIDParams
    public var resourceURL: (String, String)

    init(resourceURL: (String, String), params: RetweetersIDParams, fetchOlder: Bool?, nextCursor: String?, previousCursor: String?) {
        
        self.resourceURL = resourceURL
        
        self.params = params
        
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
                params.cursor = previousCursor
            }
            
            if !fetchOlder, nextCursor != "-1" {
                params.cursor = nextCursor
            }
            
            let client = RESTfulClient(resource: resourceURL, params: params.getParams())
            print(resourceURL)
            print(params.getParams())
            client.getData() { data in
                if let data = data {
                    let json = JSON(data: data)
                    print(">>> rt json >> \(json)")
                    
                    self.nextCursor = json["next_cursor_str"].stringValue
                    self.previousCursor = json["previous_cursor_str"].stringValue
                    
                    let idList = json["ids"].arrayValue.map({ $0.stringValue })
                    
                    handler(self.nextCursor, self.previousCursor, idList)
                }
            }
        }
    }

}
