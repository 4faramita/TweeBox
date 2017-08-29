//
//  ResourceURL.swift
//  TweeBox
//
//  Created by 4faramita on 2017/7/28.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

struct ResourceURL {
    
    // GET
    
    static let user_lookup = (url: "https://api.twitter.com/1.1/users/lookup.json", method: "GET")
    /*
     Returns fully-hydrated user objects for up to 100 users per request, as specified by comma-separated values passed to the user_id and/or screen_name parameters.
     
     This method is especially useful when used in conjunction with collections of user IDs returned from GET friends / ids and GET followers / ids.
     */
    
    static let user_show = (url: "https://api.twitter.com/1.1/users/show.json", method: "GET")
    
    static let users_search = (url: "https://api.twitter.com/1.1/users/search.json", method: "GET")
    
    
    static let statuses_show_id = (url: "https://api.twitter.com/1.1/statuses/show.json", method: "GET")
    
    static let statuses_retweeters_ids = (url: "https://api.twitter.com/1.1/statuses/retweeters/ids.json", method: "GET")
    
    static let statuses_home_timeline = (url: "https://api.twitter.com/1.1/statuses/home_timeline.json", method: "GET")
    
    static let statuses_user_timeline = (url: "https://api.twitter.com/1.1/statuses/user_timeline.json", method: "GET")
    
    static let statuses_mentions_timeline = (url: "https://api.twitter.com/1.1/statuses/mentions_timeline.json", method: "GET")
    
    
    static let followers_list = (url: "https://api.twitter.com/1.1/followers/list.json", method: "GET")
    
    static let followings_list = (url: "https://api.twitter.com/1.1/friends/list.json", method: "GET")
    
    
    static let search_tweets = (url: "https://api.twitter.com/1.1/search/tweets.json", method: "GET")
    
    
    
    // POST
    
    static let statuses_destroy_id = (url: "https://api.twitter.com/1.1/statuses/destroy/:id.json", method: "POST")
    
    static let statuses_unretweet_id = (url: "https://api.twitter.com/1.1/statuses/unretweet/:id.json", method: "POST")
    
    static let statuses_retweet_id = (url: "https://api.twitter.com/1.1/statuses/retweet/:id.json", method: "POST")
    
    
    static let favorites_create = (url: "https://api.twitter.com/1.1/favorites/create.json", method: "POST")
    
    static let favorites_destroy = (url: "https://api.twitter.com/1.1/favorites/destroy.json", method: "POST")

    
    static let users_report_spam = (url: "https://api.twitter.com/1.1/users/report_spam.json", method: "POST")
}
