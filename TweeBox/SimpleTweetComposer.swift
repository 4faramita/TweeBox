//
//  SimpleTweetComposer.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/29.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation


struct SimpleTweetComposer {
    
    var id: String
    
    func retweet(handler: @escaping (Bool, Tweet?) -> Void) {
        
        let params = SimplePostParams(id: id)
        
        let dataRetriever = SimpleTweetPoster(tweetParams: params, resourceURL: ResourceURL.statuses_retweet_id)
        
        dataRetriever.postData { (retweet) in
            if self.id == retweet?.retweetedStatus?.id {
                handler(true, retweet)
            } else {
                handler(false, retweet)
            }
        }
        handler(false, nil)
    }
    
    func unRetweet(handler: @escaping (Bool, Tweet?) -> Void) {
        
        let params = SimplePostParams(id: id)
        
        let dataRetriever = SimpleTweetPoster(tweetParams: params, resourceURL: ResourceURL.statuses_unretweet_id)
        
        dataRetriever.postData { (retweet) in
            if self.id == retweet?.retweetedStatus?.id {
                handler(true, retweet)
            } else {
                handler(false, retweet)
            }
        }
        handler(false, nil)
    }
    
    func deleteTweet(handler: @escaping (Bool, Tweet?) -> Void) {
        
        let params = SimplePostParams(id: id)
        
        let dataRetriever = SimpleTweetPoster(tweetParams: params, resourceURL: ResourceURL.statuses_destroy_id)
        
        dataRetriever.postData { (retweet) in
            if self.id == retweet?.retweetedStatus?.id {
                handler(true, retweet)
            } else {
                handler(false, retweet)
            }
        }
        handler(false, nil)
    }
}
