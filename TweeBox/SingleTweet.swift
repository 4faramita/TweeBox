//
//  SingleTweet.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/21.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON


class SingleTweet {
    
    //    private var user: TwitterUser!
    
    public var resourceURL: (String, String)
    public var tweetParams: TweetParams
    
    init(tweetParams: TweetParams, resourceURL: (String, String)) {
        self.resourceURL = resourceURL
        self.tweetParams = tweetParams
    }
    
    public func fetchData(_ handler: @escaping (Tweet?) -> Void) {
        if Constants.selfID != "-1" {
            let client = RESTfulClient(resource: resourceURL, params: tweetParams.getParams())
            
            client.getData() { data in
                if let data = data {
                    let json = JSON(data: data)
                    if json.null == nil {
                        let tweet = Tweet(with: json)
                        handler(tweet)
                    }
                }
            }
        }
    }
}
