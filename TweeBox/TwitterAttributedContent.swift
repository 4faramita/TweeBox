//
//  TwitterAttributedContent.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/19.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import UIKit
import YYText
import SafariServices


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
    
    private func changeColorAttribute(to entity: TweetEntity, with color: UIColor?) -> NSRange? {
        
        let start = plainString.index(plainString.startIndex, offsetBy: entity.indices[0], limitedBy: plainString.endIndex)
        let end = plainString.index(plainString.startIndex, offsetBy: entity.indices[1], limitedBy: plainString.endIndex)
        if let start = start, let end = end {
            
            let stringToBeRender = plainString.substring(with: start..<end)
            
            let range = NSPlainString.range(of: stringToBeRender)
            
//            attributed.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
            if let url = entity as? TweetURL {
                
                attributed.yy_setTextHighlight(
                    range,
                    color: color ?? Constants.themeColor,
                    backgroundColor: nil,
                    userInfo: nil,
                    tapAction: { (containerView, attributedString, range, rect) in
                        if let realURL = url.url {
                            let safariViewController = SFSafariViewController(url: realURL, entersReaderIfAvailable: true)
                            containerView.yy_viewController?.present(safariViewController, animated: true)
                        }
                    },
                    longPressAction: nil
                )
            } else if entity is Hashtag {
                
                attributed.yy_setTextHighlight(
                    range,
                    color: color ?? Constants.themeColor,
                    backgroundColor: nil,
                    userInfo: nil,
                    tapAction: { [weak self] (containerView, attributedString, range, rect) in
                        if let sourceViewController = containerView.yy_viewController as? SingleTweetViewController {
                            
                            let keyword = (attributedString.string as NSString).substring(with: range)
                            sourceViewController.keyword = keyword
                            sourceViewController.performSegue(withIdentifier: "Show Tweets with Hashtag", sender: self)
                        }
                    },
                    longPressAction: nil
                )

            } else if entity is Mention {
                attributed.yy_setTextHighlight(
                    range,
                    color: color ?? Constants.themeColor,
                    backgroundColor: nil,
                    userInfo: nil,
                    tapAction: { [weak self] (containerView, attributedString, range, rect) in
                        
                        if let sourceViewController = containerView.yy_viewController as? SingleTweetViewController {
                            
                            let keyword = (attributedString.string as NSString).substring(with: range)
                            sourceViewController.keyword = keyword
                            
                            SingleUser(
                                userParams: UserParams(userID: nil, screenName: keyword),
                                resourceURL: ResourceURL.user_show
                            ).fetchData { (singleUser) in
                                print(">>> detching user")
                                    
                                if let user = singleUser {
                                    sourceViewController.fetchedUser = user
                                    sourceViewController.performSegue(withIdentifier: "Show User", sender: self)
                                } else {
                                    sourceViewController.alertForNoSuchUser(viewController: sourceViewController)
                                }
                            }
                        }
                    },
                    longPressAction: nil
                )
                
            } else {
                attributed.yy_setTextHighlight(
                    range,
                    color: color ?? Constants.themeColor,
                    backgroundColor: nil,
                    userInfo: nil,
                    tapAction: { (containerView, attributedString, range, rect) in
                        print(">>> Unknown entity >> \(attributedString)")                    },
                    longPressAction: nil
                )
            }

            
            return range
            
        } else {
            return nil
        }
    }
    
    
//    fileprivate func fetchUser(keyword: String, _ handler: @escaping (TwitterUser?) -> Void) {
//        
//        SingleUser(
//            userParams: UserParams(userID: nil, screenName: keyword),
//            resourceURL: ResourceURL.user_show
//            ).fetchData { (singleUser) in
//                handler(singleUser)
//        }
//    }

    
    private func getAttributedContent() -> NSAttributedString {
        
        attributed = NSMutableAttributedString.init(string: plainString)
        
        if user != nil {
            let range = NSRange.init(location: 0, length: attributed.length)
            let descriptionFont = UIFont.preferredFont(forTextStyle: .caption2)
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
            if let range = range {
                attributed.mutableString.replaceCharacters(in: range, with: "")
            }
        }
        
        return attributed
    }
}
