//
//  ResourceURL.swift
//  TweeBox
//
//  Created by 4faramita on 2017/7/28.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

struct ResourceURL {
    static let user_timeline = (url: "https://api.twitter.com/1.1/statuses/user_timeline.json", method: "GET")
    
    static let user_lookup = (url: "https://api.twitter.com/1.1/users/lookup.json", method: "GET")
    /*
     Returns fully-hydrated user objects for up to 100 users per request, as specified by comma-separated values passed to the user_id and/or screen_name parameters.
     
     This method is especially useful when used in conjunction with collections of user IDs returned from GET friends / ids and GET followers / ids.
     */
    
    static let user_show = (url: "https://api.twitter.com/1.1/users/show.json", method: "GET")
    
    static let statuses_show_id = (url: "https://api.twitter.com/1.1/statuses/show.json", method: "GET")
    
    static let followers_list = (url: "https://api.twitter.com/1.1/followers/list.json", method: "GET")
    
    static let followings_list = (url: "https://api.twitter.com/1.1/friends/list.json", method: "GET")
    
    static let home_timeline = (url: "https://api.twitter.com/1.1/statuses/home_timeline.json", method: "GET")
    
    static let search_tweets = (url: "https://api.twitter.com/1.1/search/tweets.json", method: "GET")
}
