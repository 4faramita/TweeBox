//
//  Timeline.swift
//  TweeBox
//
//  Created by 4faramita on 2017/7/28.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON

class Timeline {
    public var timeline = [Tweet]()    
    public var maxID: String?
    public var sinceID: String?
    public var fetchNewer: Bool
    public var resourceURL: (String, String)
    public var timelineParams: ParamsWithBoundsProtocol
    
    init(maxID: String?, sinceID: String?, fetchNewer: Bool = true, resourceURL: (String, String), timelineParams: ParamsWithBoundsProtocol) {
        
        self.maxID = maxID
        self.sinceID = sinceID
        
        self.fetchNewer = fetchNewer
        
        self.resourceURL = resourceURL
        self.timelineParams = timelineParams
    }
    
    func appendTweet(from json: JSON) {
        
        for (_, tweetJSON) in json {
            if tweetJSON.null == nil {
                let tweet = Tweet(with: tweetJSON)
                self.timeline.append(tweet)  // mem cycle?
            }
        }

    }
    
    public func fetchData(_ handler: @escaping (String?, String?, [Tweet]) -> Void) {
        
        if Constants.selfID != "-1" {
            
            if fetchNewer, sinceID != nil {
                timelineParams.sinceID = String(Int(sinceID!)! + 1)
            }
            
            if !fetchNewer, maxID != nil {
                timelineParams.maxID = String(Int(maxID!)! - 1)
            }
            
            let client = RESTfulClient(resource: resourceURL, params: timelineParams.getParams())
            print(">>> params \(timelineParams.getParams())")
            client.getData() { data in
                if let data = data {
                    let json = JSON(data: data)
                    
                    self.appendTweet(from: json)
                    
                    self.maxID = self.timeline.last?.id  // if fetch tweets below this batch, the earliest one in this batch would be the max one for the next batch
                    self.sinceID = self.timeline.first?.id  // vice versa
                    
                    handler(self.maxID, self.sinceID, self.timeline)
                } else {
                    handler(self.maxID, self.sinceID, self.timeline)
                }
            }
        }
    }
}
