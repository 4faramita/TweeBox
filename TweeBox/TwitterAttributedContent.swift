//
//  TwitterAttributedContent.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/19.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import UIKit


class TwitterAttributedContent {
    
    public var tweet: Tweet?
    
    public var user: TwitterUser?
    
    private var plainString: String {
        return (tweet?.text) ?? (user?.description) ?? ""
    }
    
    private var tweetEntity: Entity? {
        return (tweet?.entities) ?? (user?.entities)
    }
    
    init(_ tweet: Tweet) {
        self.tweet = tweet
    }
    
    init(_ user: TwitterUser) {
        self.user = user
    }
    
    public var attributedString: NSAttributedString {
        return getAttributedContent()
    }
    
    private func getAttributedContent() -> NSAttributedString {
        
        let attributed = NSMutableAttributedString.init(string: plainString)
        
        if let hashtags = tweetEntity?.hashtags {
            for hashtag in hashtags {
                let range = NSRange.init(location: hashtag.indices[0], length: hashtag.indices[1] - hashtag.indices[0])
                attributed.addAttribute(NSForegroundColorAttributeName, value: Constants.lightenThemeColor, range: range)
            }
        }
        
        if let mentions = tweetEntity?.userMentions {
            for mention in mentions {
                let range = NSRange.init(location: mention.indices[0], length: mention.indices[1] - mention.indices[0])
                attributed.addAttribute(NSForegroundColorAttributeName, value: Constants.themeColor, range: range)
            }
        }
        
        if let urls = tweetEntity?.urls {
            for url in urls {
                let range = NSRange.init(location: url.indices[0], length: url.indices[1] - url.indices[0])
                attributed.addAttribute(NSForegroundColorAttributeName, value: Constants.themeColor, range: range)
            }
        }
        
        if let symbols = tweetEntity?.symbols {
            for symbol in symbols {
                let range = NSRange.init(location: symbol.indices[0], length: symbol.indices[1] - symbol.indices[0])
                attributed.addAttribute(NSForegroundColorAttributeName, value: Constants.themeColor, range: range)
            }
        }
        
        if let media = tweetEntity?.media, media.count > 0 {
            let firstMedia = media[0]
            let range = NSRange.init(location: firstMedia.indices[0], length: firstMedia.indices[1] - firstMedia.indices[0])
            attributed.mutableString.replaceCharacters(in: range, with: "")
        }
        
//        if user != nil {
//            let range = NSRange(location: 0, length: plainString.lengthOfBytes(using: .utf8))
//            let descriptionFont = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 12)
//            attributed.addAttribute(NSFontAttributeName, value: descriptionFont, range: range)
//        }
        
        return attributed
    }
}
