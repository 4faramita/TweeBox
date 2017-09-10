//
//  TweetPoster.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/30.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData


class TweetPoster {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    private let resourceURL = ResourceURL.statuses_update
    public var tweetParams: TweetPostParams
    
    
    init(tweetParams: TweetPostParams) {
        self.tweetParams = tweetParams
    }

    
    func postData(_ handler: @escaping (Tweet?) -> Void) {
        
        if Constants.selfID != "-1" {
            let client = RESTfulClient(resource: resourceURL, params: tweetParams.getParams())
            
            print(">>> TweetPoster >> \(tweetParams.getParams())")
            
            client.getData() { [weak self] data in
                if let data = data {
                    let json = JSON(data: data)
                    if json.null == nil {
                        self?.container?.performBackgroundTask({ (context) in
                            if let tweet = try? Tweet.matchOrCreateTweet(with: json, in: context) {
                                context.perform {
                                    handler(tweet)
                                }
                            }
                        })
                    } else {
                        handler(nil)
                    }
                } else {
                    handler(nil)
                }
            }
        }
    }

}
