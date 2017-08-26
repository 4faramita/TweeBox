//
//  Entity.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/5.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Entity {
    
    public var hashtags: [Hashtag]
    public var urls: [TweetURL]
    public var userMentions: [Mention]
    public var symbols: [TweetSymbol]
    
    public var media: [TweetMedia]?
    public var realMedia: [TweetMedia]?
    public var mediaToShare: [TweetMedia]?
    public var thumbMedia: [TweetMedia]?
    
    
    
    
    
    
    init(with json: JSON, and extendedJson: JSON) {
        
        hashtags     = json["hashtags"].arrayValue.map { Hashtag(with: $0) }
        urls         = json["urls"].arrayValue.map { TweetURL(with: $0) }
        userMentions = json["user_mentions"].arrayValue.map { Mention(with: $0) }
        symbols      = json["symbols"].arrayValue.map { TweetSymbol(with: $0) }
                
        if extendedJson.null == nil {
            // there exists extended_json
            media = extendedJson["media"].arrayValue.map { TweetMedia(with: $0, quality: MediaSize.small) }
            realMedia = extendedJson["media"].arrayValue.map { TweetMedia(with: $0, quality: Constants.picQuality) }
            mediaToShare = extendedJson["media"].arrayValue.map { TweetMedia(with: $0, quality: .nonNormal) }
            thumbMedia = extendedJson["media"].arrayValue.map { TweetMedia(with: $0, quality: MediaSize.thumb) }
            // media in extended_entities
        }
    }
}
