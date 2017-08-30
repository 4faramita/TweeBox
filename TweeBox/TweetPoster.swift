//
//  TweetPoster.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/30.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON


class TweetPoster {
    
    private let resourceURL = ResourceURL.statuses_update
    public var tweetParams: TweetPostParams
    
    
    init(tweetParams: TweetPostParams) {
        self.tweetParams = tweetParams
    }

    
    func postData(_ handler: @escaping (Tweet?) -> Void) {
        
        if Constants.selfID != "-1" {
            let client = RESTfulClient(resource: resourceURL, params: tweetParams.getParams())
            
            print(">>> TweetPoster >> \(tweetParams.getParams())")
            
            client.getData() { data in
                if let data = data {
                    let json = JSON(data: data)
                    if json.null == nil {
                        let tweet = Tweet(with: json)
                        handler(tweet)
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
