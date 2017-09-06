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
        
        let dataRetriever = SimpleTweetPoster(params: params, resourceURL: ResourceURL.statuses_retweet_id)
        
        dataRetriever.postData { (retweet) in
            if self.id == retweet?.retweetedStatus?.id {
                handler(true, retweet)
            } else {
                handler(false, retweet)
            }
        }
    }
    
    
    func unRetweet(handler: @escaping (Bool, Tweet?) -> Void) {
        
        let params = SimplePostParams(id: id)
        
        let dataRetriever = SimpleTweetPoster(params: params, resourceURL: ResourceURL.statuses_unretweet_id)
        
        dataRetriever.postData { (retweet) in
            if self.id == retweet?.retweetedStatus?.id {
                handler(true, retweet)
            } else {
                handler(false, retweet)
            }
        }
    }
    
    
    func deleteTweet(handler: @escaping (Bool, Tweet?) -> Void) {
        
        let params = SimplePostParams(id: id)
        
        let dataRetriever = SimpleTweetPoster(params: params, resourceURL: ResourceURL.statuses_destroy_id)
        
        dataRetriever.postData { (tweet) in
//            if self.id == tweet?.id {
//                handler(true, tweet)
//            } else {
//                handler(false, tweet)
//            }
        }
        handler(true, nil)
        // FIX THIS!

    }
    
    
    func like(handler: @escaping (Bool, Tweet?) -> Void) {
        
        let params = SimplePostParams(id: id)
        
        let dataRetriever = FavoritePoster(params: params, resourceURL: ResourceURL.favorites_create)
        
        dataRetriever.postData { (tweet) in
            if self.id == tweet?.id {
                handler(true, tweet)
            } else {
                handler(false, tweet)
            }
        }
    }
    
    
    func dislike(handler: @escaping (Bool, Tweet?) -> Void) {
        
        let params = SimplePostParams(id: id)
        
        let dataRetriever = FavoritePoster(params: params, resourceURL: ResourceURL.favorites_destroy)
        
        dataRetriever.postData { (tweet) in
            if self.id == tweet?.id {
                handler(true, tweet)
            } else {
                handler(false, tweet)
            }
        }
    }
}
