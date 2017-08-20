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
    
    private var NSPlainString: NSString {
        return plainString as NSString
    }
    
    private var attributed: NSMutableAttributedString!
    
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
    
    private func changeColorAttribute(to entity: TweetEntity, with color: UIColor?) -> NSRange {
        
        let start = plainString.index(plainString.startIndex, offsetBy: entity.indices[0])
        let end = plainString.index(plainString.startIndex, offsetBy: entity.indices[1])
        let stringToBeRender = plainString.substring(with: start..<end)
        
        let range = NSPlainString.range(of: stringToBeRender)
        
        if let color = color {
            attributed.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        }

        return range
    }
    
    private func getAttributedContent() -> NSAttributedString {
        
        attributed = NSMutableAttributedString.init(string: plainString)
        
        if user != nil {
            let range = NSRange.init(location: 0, length: attributed.length)
            let descriptionFont = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 12)
            attributed.addAttribute(NSFontAttributeName, value: descriptionFont, range: range)
            attributed.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: range)
        }
        
        if let hashtags = tweetEntity?.hashtags {
            for hashtag in hashtags {
                let _ = changeColorAttribute(to: hashtag, with: Constants.lightenThemeColor)
            }
        }
        
        if let mentions = tweetEntity?.userMentions {
            for mention in mentions {
                let _ = changeColorAttribute(to: mention, with: Constants.themeColor)
            }
        }
        
        if let urls = tweetEntity?.urls {
            for url in urls {
                let _ = changeColorAttribute(to: url, with: Constants.themeColor)
            }
        }
        
        if let symbols = tweetEntity?.symbols {
            for symbol in symbols {
                let _ = changeColorAttribute(to: symbol, with: Constants.themeColor)
            }
        }
        
        if let media = tweetEntity?.media, media.count > 0 {
            
            let firstMedia = media[0]
            
            let range = changeColorAttribute(to: firstMedia, with: nil)
            
            attributed.mutableString.replaceCharacters(in: range, with: "")
        }
        
        return attributed
    }
}
