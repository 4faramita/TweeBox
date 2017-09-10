//
//  GeneralTweetTableViewCell.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/27.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit
import YYText
import Kingfisher
import DateToolsSwift
import VisualEffectView
import SwipeCellKit

protocol GeneralTweetTableViewCellProtocol: class {
    
    func profileImageTapped(section: Int, row: Int)
    
    func imageTapped(section: Int, row: Int, mediaIndex: Int, media: [TweetMedia])
    
    func originTweetTapped(section: Int, row: Int)
}


class GeneralTweetTableViewCell: SwipeTableViewCell {
    
    
    // tap to segue
    weak var tapDelegate: GeneralTweetTableViewCellProtocol?
    
    var section: Int?
    var row: Int?
    var mediaIndex: Int? {
        didSet {
            imageTapped()
        }
    }
    
    var isRetweet = false
    
    var isQuote: Bool {
        return (tweet?.quotedStatus != nil)
    }
    
    var retweet: Tweet?
    
//    var quoted: Tweet?
    
    var tweet: Tweet? {
        didSet {
            if let originTweet = tweet?.retweetedStatus
//                , let retweetText = tweet?.text, retweetText.hasPrefix("RT @") 
            {
                isRetweet = true
                retweet = tweet
                tweet = originTweet
            }
            
            updateUI()
        }
    }

    

    @IBOutlet weak var tweetUserProfileImage: UIImageView!
    @IBOutlet weak var tweetCreatedTime: UILabel!
    @IBOutlet weak var tweetUserName: UILabel!
    @IBOutlet weak var tweetUserScreenName: UILabel!
    
    @IBOutlet weak var tweetTextContentLabel: YYLabel!
    
    @IBOutlet weak var tweetMediaContentView: TweetMediaContainerView?
    
    @IBOutlet weak var quoteTweetContainerView: OriginTweetView?
    
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var retweeterProfileImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    
    
    func updateUI() {
        
        if isQuote, let quoteTweetContainerView = quoteTweetContainerView, let originTweet = tweet?.quotedStatus {
            
            quoteTweetContainerView.originTweet = originTweet
            
            let tapOnOriginTweet = UITapGestureRecognizer(
                target: self,
                action: #selector(originTweetTapped(byReactingTo:))
            )
            tapOnOriginTweet.numberOfTapsRequired = 1
            tapOnOriginTweet.numberOfTouchesRequired = 1
            quoteTweetContainerView.addGestureRecognizer(tapOnOriginTweet)

            
        } else if let tweet = tweet, let tweetMediaContentView = tweetMediaContentView, let media = tweet.entities?.media {
            
            tweetMediaContentView.tweet = tweet
            
            if media.count == 1 {
                
                let media = media.allObjects as! [TweetMedia]
                if media[0].type != "photo" {
                    addPlayLabel(to: tweetMediaContentView, isGif: (media[0].type == "animated_gif"))
                }
            }
            
        }
        
        tweetMediaContentView?.cutToRound(radius: 5)

        
        if let userProfileImageURL = tweet?.user?.profileImageURL, let userProfileImageView = self.tweetUserProfileImage {
            
            userProfileImageView.kf.setImage(
                with: userProfileImageURL.url,
//                placeholder: placeholder,
                options: [
                    .transition(.fade(Constants.picFadeInDuration)),
                    ]
            )
            
//            picView.layer.borderWidth = 3.0
//            picView.layer.borderColor = UIColor.lightGray.cgColor
            
            userProfileImageView.cutToRound(radius: nil)
            
            // tap to segue
            let tapOnProfileImage = UITapGestureRecognizer(
                target: self,
                action: #selector(profileImageTapped(byReactingTo:))
            )
            tapOnProfileImage.numberOfTapsRequired = 1
            userProfileImageView.addGestureRecognizer(tapOnProfileImage)
            userProfileImageView.isUserInteractionEnabled = true
        } else {
            tweetUserProfileImage?.image = nil
        }
        
        
        if let created = tweet?.createdTime {
            self.tweetCreatedTime?.text = (created as Date).shortTimeAgoSinceNow
        } else {
            tweetCreatedTime?.text = nil
        }
        
        tweetUserName.text = tweet?.user?.name
        
        if let screenName = tweet?.user?.screenName {
            tweetUserScreenName.text = "@\(screenName)"
        }
        
        if let tweet = tweet {
            tweetTextContentLabel?.attributedText = TwitterAttributedContent(tweet).attributedString
            
            tweetTextContentLabel?.lineBreakMode = .byWordWrapping
            tweetTextContentLabel?.numberOfLines = 0
            tweetTextContentLabel?.textAlignment = .natural
            tweetTextContentLabel?.preferredMaxLayoutWidth = (tweetMediaContentView?.bounds.width ?? 281)
            tweetTextContentLabel?.font = UIFont.preferredFont(forTextStyle: .body)

        }

        
        
        if (tweet?.inReplyToStatusID) != nil {
            replyImage.image = UIImage(named: "reply_true")
        } else {
            replyImage.image = UIImage(named: "reply_false")
        }
        
        let retweetedTweet = tweet?.retweeted ?? false
        let retweetedRetweet = retweet?.retweeted ?? false
        let retweeted = (retweetedTweet || retweetedRetweet)
        
        if retweeted {
            retweeterProfileImage?.removeFromSuperview()
            retweetImage.image = UIImage(named: "retweet_true")
            retweetLabel.text = tweet?.retweetCount.shortExpression
        } else {
            retweetImage.image = UIImage(named: "retweet_false")
            
            if isRetweet, let retweet = retweet {
                
                retweetLabel.text = retweet.user?.name
                retweeterProfileImage?.kf.setImage(with: retweet.user?.profileImageURL)
                retweeterProfileImage?.cutToRound(radius: 8)
                
            } else {
                retweeterProfileImage?.removeFromSuperview()
                retweetLabel.text = tweet?.retweetCount.shortExpression
            }
        }
        
        likeLabel.text = (tweet?.favoriteCount ?? 0).shortExpression
        
        let likedTweet = tweet?.favorited ?? false
        let likedRetweet = retweet?.favorited ?? false
        let liked = (likedTweet || likedRetweet)
        
        if liked {
            likeImage.image = UIImage(named: "like_true")
        } else {
            likeImage.image = UIImage(named: "like_false")
        }
    }
    
    
    private func addPlayLabel(to view: UIView, isGif: Bool) {
        
        let visualEffectView = VisualEffectView(frame: view.bounds)
        visualEffectView.blurRadius = 2
        visualEffectView.colorTint = .white
        visualEffectView.colorTintAlpha = 0.2
        visualEffectView.isUserInteractionEnabled = false
        visualEffectView.isOpaque = false
        view.addSubview(visualEffectView)
        
        let play = UIImageView(image: UIImage(named: "play_video"))
        play.isUserInteractionEnabled = false
        play.isOpaque = false
        view.addSubview(play)
        play.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.height.equalTo(32)
            make.width.equalTo(32)
        }
        
        if isGif {
            let gif = UIImageView(image: UIImage(named: "play_gif"))
            gif.isUserInteractionEnabled = false
            gif.isOpaque = false
            view.addSubview(gif)
            gif.snp.makeConstraints { (make) in
                make.trailing.equalTo(view).offset(-10)
                make.bottom.equalTo(view)
                make.height.equalTo(32)
                make.width.equalTo(32)
            }
        }
    }
}


extension GeneralTweetTableViewCell {
    
    @IBAction func profileImageTapped(byReactingTo: UIGestureRecognizer) {
        guard let section = section, let row = row else { return }
        tapDelegate?.profileImageTapped(section: section, row: row)
    }
    
    @IBAction func imageTapped() {
        
        guard let section = section, let row = row, let mediaIndex = mediaIndex else { return }
        tapDelegate?.imageTapped(section: section, row: row, mediaIndex: mediaIndex, media: (tweet?.entities?.media as! [TweetMedia]))
    }
    
    @IBAction func originTweetTapped(byReactingTo: UIGestureRecognizer) {
        guard let section = section, let row = row else { return }
        tapDelegate?.originTweetTapped(section: section, row: row)
    }
    
}
