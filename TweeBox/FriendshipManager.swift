//
//  FriendshipManager.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/29.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

struct FriendshipManager {
    
    var userID: String
    
    func follow(handler: @escaping (Bool, TwitterUser?) -> Void) {
        
        let params = SimpleUserParams(userID: userID, screenName: nil)
        
        let dataRetriever = FriendshipPoster(userParams: params, resourceURL: ResourceURL.friendships_create)
        
        dataRetriever.postData { (user) in
            if self.userID == user?.id {
                handler(true, user)
            } else {
                handler(false, user)
            }
        }
    }
    
    
    func unfollow(handler: @escaping (Bool, TwitterUser?) -> Void) {
        
        let params = SimpleUserParams(userID: userID, screenName: nil)
        
        let dataRetriever = FriendshipPoster(userParams: params, resourceURL: ResourceURL.friendships_destroy)
        
        dataRetriever.postData { (user) in
            if self.userID == user?.id {
                handler(true, user)
            } else {
                handler(false, user)
            }
        }
    }
    
    func block(handler: @escaping (Bool, TwitterUser?) -> Void) {
        
        let params = SimpleUserParams(userID: userID, screenName: nil)
        
        let dataRetriever = FriendshipPoster(userParams: params, resourceURL: ResourceURL.blocks_create)
        
        dataRetriever.postData { (user) in
            if self.userID == user?.id {
                handler(true, user)
            } else {
                handler(false, user)
            }
        }
    }

    
    func unblock(handler: @escaping (Bool, TwitterUser?) -> Void) {
        
        let params = SimpleUserParams(userID: userID, screenName: nil)
        
        let dataRetriever = FriendshipPoster(userParams: params, resourceURL: ResourceURL.blocks_destroy)
        
        dataRetriever.postData { (user) in
            if self.userID == user?.id {
                handler(true, user)
            } else {
                handler(false, user)
            }
        }
    }
    
    
    func reportSpam(block: Bool?, handler: @escaping (Bool, TwitterUser?) -> Void) {
        
        let params = SpamUserParams(userID: userID, screenName: nil, performBlock: block)
        
        let dataRetriever = FriendshipPoster(userParams: params, resourceURL: ResourceURL.users_report_spam)
        
        dataRetriever.postData { (user) in
            if self.userID == user?.id {
                handler(true, user)
            } else {
                handler(false, user)
            }
        }
    }


}
