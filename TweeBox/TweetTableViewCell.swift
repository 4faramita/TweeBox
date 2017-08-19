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
}

class TweetTableViewCell: UITableViewCell {
    
    // tap to segue
    weak var delegate: TweetWithPicTableViewCellProtocol?
    weak var profilrDelegate: TweetTableViewCellProtocol?
    
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
    @IBOutlet weak var likeImage: UIImageView!
    
    
    
    @IBAction func profileImageTapped(byReactingTo: UIGestureRecognizer) {
        guard let section = section, let row = row else { return }
        profilrDelegate?.profileImageTapped(section: section, row: row)
    }
    
    
//    private func cutViewToRound(with someView: UIView, radius: CGFloat?) {
//        someView.layer.cornerRadius = radius ?? (someView.frame.size.width / 2)
//        someView.clipsToBounds = true
//    }
    
    
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
        if let mainTweetID = tweet?.inReplyToStatusID {
            replyImage.image = UIImage(named: "reply_true")
        } else {
            replyImage.image = UIImage(named: "reply_false")
        }
        
        var shortedRtCount = ""
        if let retweetCount = tweet?.retweetCount {
            if retweetCount > 10000 {
                shortedRtCount = "\(Float(retweetCount) / 1000)k"
            } else {
                shortedRtCount = "\(retweetCount)"
            }
        }
        
        let retweetedTweet = tweet?.retweeted ?? false
        let retweetedRetweet = retweet?.retweeted ?? false
        let retweeted = (retweetedTweet || retweetedRetweet)
        
        if retweeted {
            retweetImage.image = UIImage(named: "retweet_true")
            retweetCount.text = shortedRtCount
        } else {
            retweetImage.image = UIImage(named: "retweet_false")
            
            if let retweet = retweet {

                retweetCount.text = retweet.user.name
                
                let retweeterProfileImage = UIImageView()
                addSubview(retweeterProfileImage)
                retweeterProfileImage.kf.setImage(with: retweet.user.profileImageURL)
                retweeterProfileImage.snp.makeConstraints({ (make) in
                    make.height.equalTo(16)
                    make.width.equalTo(16)
                    make.top.equalTo(retweetCount)
                    make.leading.equalTo(retweetImage.snp.trailing).offset(3)
                    make.trailing.equalTo(retweetCount.snp.leading).offset(-2)
                })
                retweeterProfileImage.cutToRound(radius: 8)
                
            } else {
                retweetCount.text = shortedRtCount
            }
        }
        
        var shortenFavCount = ""
        if let favoriteCount = tweet?.favoriteCount {
            if favoriteCount > 10000 {
                shortenFavCount = "\(Float(favoriteCount) / 1000)k"
            } else {
                shortenFavCount = "\(favoriteCount)"
            }
        }
        likeCount.text = shortenFavCount
        
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
