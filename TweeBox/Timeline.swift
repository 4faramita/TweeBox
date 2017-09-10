//
//  Timeline.swift
//  TweeBox
//
//  Created by 4faramita on 2017/7/28.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData


class Timeline {
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    public var timeline = [Tweet]()
    public var maxID: String?
    public var sinceID: String?
    public var fetchNewer: Bool
    public var resourceURL: (String, String)
    public var params: ParamsWithBoundsProtocol
    
    init(maxID: String?, sinceID: String?, fetchNewer: Bool = true, resourceURL: (String, String), params: ParamsWithBoundsProtocol) {
        
        self.maxID = maxID
        self.sinceID = sinceID
        
        self.fetchNewer = fetchNewer
        
        self.resourceURL = resourceURL
        self.params = params
    }
    
    func appendTweet(with json: JSON) {
                
        container?.performBackgroundTask({ [weak self] (context) in
            for (_, tweetJSON) in json {
                if tweetJSON.null == nil {
                    //                let tweet = Tweet(with: tweetJSON)
                    if let tweet = try? Tweet.matchOrCreateTweet(with: tweetJSON, in: context) {
                        context.perform {
                            self?.addToTimeline(tweet)
                            // may not need local timeline
                        }
                    }
                }
            }
            try? context.save()
        })
    }
    
    func addToTimeline(_ tweet: Tweet) {
        self.timeline.append(tweet)
    }

    
    public func fetchData(_ handler: @escaping (String?, String?, [Tweet]) -> Void) {
        
        if Constants.selfID != "-1" {
            
            if fetchNewer, sinceID != nil {
                params.sinceID = String(Int(sinceID!)! + 1)
            }
            
            if !fetchNewer, maxID != nil {
                params.maxID = String(Int(maxID!)! - 1)
            }
            
            let client = RESTfulClient(resource: resourceURL, params: params.getParams())
            print(">>> params \(params.getParams())")
            client.getData() { data in
                if let data = data {
                    let json = JSON(data: data)
                    
                    self.appendTweet(with: json)
                    
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
