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
import SwiftyJSON


class TwitterAttributedContent {
    
    public var tweet: Tweet?
    
    public var user: TwitterUser?
    
    private var plainString: String {
        return (tweet?.text) ?? (user?.description) ?? ""
    }
    
    private var attributed: NSMutableAttributedString!
    
    private var tweetEntity: Entity? {
        return tweet?.tweetEntities ?? user?.userEntities
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
            
            let range = (attributed.string as NSString).range(of: stringToBeRender)
            
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
                    tapAction: { (containerView, attributedString, range, rect) in
                        if var sourceViewController = containerView.yy_viewController as? TweetClickableContentProtocol {
                            
                            let keyword = (attributedString.string as NSString).substring(with: range)
                            sourceViewController.keyword = keyword
                            sourceViewController.setAndPerformSegueForHashtag()
//                            sourceViewController.performSegue(withIdentifier: "Show Tweets with Hashtag", sender: self)
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
                        if var sourceViewController = containerView.yy_viewController as? TweetClickableContentProtocol {
                            
                            let keyword = (attributedString.string as NSString).substring(with: range)
                            sourceViewController.keyword = keyword
                            
                            SingleUser(
                                params: UserParams(userID: nil, screenName: keyword),
                                resourceURL: ResourceURL.user_show
                            ).fetchData { (singleUser) in
                                
                                if let user = singleUser {
                                    sourceViewController.fetchedUser = user
                                    sourceViewController.performSegue(withIdentifier: "profileImageTapped", sender: self)
                                } else {
                                    sourceViewController.alertForNoSuchUser(viewController: sourceViewController as! UIViewController)
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
        
        attributed = NSMutableAttributedString.init(string: plainString.stringByDecodingHTMLEntities)
        
        let fullRange = NSRange.init(location: 0, length: attributed.length)

        // Set unified paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .natural
        attributed.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: fullRange)
        
        if user != nil {
            let descriptionFont = UIFont.preferredFont(forTextStyle: .caption2)
            attributed.addAttribute(NSFontAttributeName, value: descriptionFont, range: fullRange)
            attributed.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: fullRange)
        } else {
            let fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
            attributed.addAttribute(NSForegroundColorAttributeName, value: fontColor, range: fullRange)
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
                if let range = changeColorAttribute(to: url, with: Constants.themeColor),
                    let urlString = url.displayURL?.absoluteString {
                    
                    attributed.mutableString.replaceCharacters(in: range, with: urlString)
                }
            }
        }
        
        if let symbols = tweetEntity?.symbols {
            for symbol in symbols {
                let _ = changeColorAttribute(to: symbol, with: Constants.themeColor)
            }
        }
        
        if let media = tweetEntity?.media, media.count > 0 {
            
            let firstMedia = media[0]
            
            if let range = changeColorAttribute(to: firstMedia, with: nil) {
                attributed.mutableString.replaceCharacters(in: range, with: "")
            }
        }
        
        return attributed
    }
}
