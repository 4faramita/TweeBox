//
//  TweetTableViewCell.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/8.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit
import Kingfisher
import DateToolsSwift

protocol TweetTableViewCellProtocol: class {
    
    func profileImageTapped(section: Int, row: Int)
    
    func imageTapped(section: Int, row: Int, mediaIndex: Int, media: [TweetMedia])
    
    func originTweetTapped(section: Int, row: Int)
}

class TweetTableViewCell: UITableViewCell {
    
    // tap to segue
    weak var delegate: TweetTableViewCellProtocol?
    
    var section: Int?
    var row: Int?
    var mediaIndex: Int?
    
    var retweet: Tweet?

    var tweet: Tweet? {
        didSet {
            if let originTweet = tweet?.retweetedStatus, let retweetText = tweet?.text, retweetText.hasPrefix("RT @") {
                retweet = tweet
                tweet = originTweet
            }
            updateUI()
        }
    }
    
    
    @IBOutlet weak var tweetUserProfilePic: UIImageView!
    @IBOutlet weak var tweetCreatedTime: UILabel!
    @IBOutlet weak var tweetUserName: UILabel!
    @IBOutlet weak var tweetUserID: UILabel!
    
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var retweeterProfileImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    
    
    @IBAction func profileImageTapped(byReactingTo: UIGestureRecognizer) {
        guard let section = section, let row = row else { return }
        delegate?.profileImageTapped(section: section, row: row)
    }
    
    
    func updateUI() {
        
//        if let mainTweetID = tweet?.inReplyToStatusID {
//            self.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.05)
//        }
        
        if let userProfileImageURL = tweet?.user.profileImageURL, let picView = self.tweetUserProfilePic {
            
            picView.kf.setImage(
                with: userProfileImageURL,
//                placeholder: placeholder,
                options: [
                    .transition(.fade(Constants.picFadeInDuration)),
                ]
            )
            
//            picView.layer.borderWidth = 3.0
//            picView.layer.borderColor = UIColor.lightGray.cgColor
            
            picView.cutToRound(radius: nil)
            
            // tap to segue
            let tapOnProfileImage = UITapGestureRecognizer(
                target: self,
                action: #selector(profileImageTapped(byReactingTo:))
            )
            tapOnProfileImage.numberOfTapsRequired = 1
            picView.addGestureRecognizer(tapOnProfileImage)
            picView.isUserInteractionEnabled = true            
        } else {
            tweetUserProfilePic?.image = nil
        }
        
        if let created = tweet?.createdTime {
            self.tweetCreatedTime?.text = created.shortTimeAgoSinceNow
        } else {
            tweetCreatedTime?.text = nil
        }
        
        tweetUserName.text = tweet?.user.name
        if let id = tweet?.user.screenName {
            tweetUserID.text = "@" + id
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
            retweetCount.text = tweet?.retweetCount.shortExpression
        } else {
            retweetImage.image = UIImage(named: "retweet_false")
            
            if let retweet = retweet {

                retweetCount.text = retweet.user.name
                retweeterProfileImage?.kf.setImage(with: retweet.user.profileImageURL)
                retweeterProfileImage?.cutToRound(radius: 8)
                
            } else {
                retweeterProfileImage?.removeFromSuperview()
                retweetCount.text = tweet?.retweetCount.shortExpression
            }
        }
        
        likeCount.text = (tweet?.favoriteCount ?? 0).shortExpression
        
        
        let likedTweet = tweet?.favorited ?? false
        let likedRetweet = retweet?.favorited ?? false
        let liked = (likedTweet || likedRetweet)
        
        if liked {
            likeImage.image = UIImage(named: "like_true")
        } else {
            likeImage.image = UIImage(named: "like_false")
        }
    }
}
