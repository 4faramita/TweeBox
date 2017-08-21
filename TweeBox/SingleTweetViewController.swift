//
//  SingleTweetViewController.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/21.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit

class SingleTweetViewController: UIViewController {
    
    private var retweet: Tweet?
    
    public var tweet: Tweet! {
        didSet {
            if let originTweet = tweet.retweetedStatus, tweet.text.hasPrefix("RT @") {
                retweet = tweet
                tweet = originTweet
            }
            
            if tweetID == nil {
                tweetID = tweet?.id
            }
        }
    }
    
    public var tweetID: String! {
        didSet {
            if tweet == nil {
                setTweet()
            }
        }
    }

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var textContentLabel: UILabel!
    
    @IBOutlet weak var createdTimeButton: UIButton!
    @IBOutlet weak var clientButton: UIButton!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var retweetCountButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if tweet != nil {
            setTweetContent()
        }
        
        if tweetID != nil {
            refreshReply()
        }

    }
    
    
    private func setTweetContent() {
        
        profileImageView.kf.setImage(with: tweet.user.profileImageURL)
        profileImageView.cutToRound(radius: nil)
        
        nameLabel.text = tweet.user.name
        screenNameLabel.text = "@\(tweet.user.screenName)"
        textContentLabel.attributedText = TwitterAttributedContent(tweet).attributedString
//        textContentLabel.numberOfLines = 0
//        textContentLabel.lineBreakMode = .byWordWrapping
        
        createdTimeButton.titleLabel?.text = tweet.createdTime?.description
        clientButton.titleLabel?.text = tweet.source
        likeCountButton.titleLabel?.text = "\((tweet.favoriteCount) ?? 0).shortExpression) like"
        retweetCountButton.titleLabel?.text = "\(tweet.retweetCount.shortExpression) retweet"
    }
    
    
    private func setTweet() {
        SingleTweet(tweetParams: TweetParams(of: tweetID!), resourceURL: ResourceURL.statuses_show_id).fetchData { [weak self] (tweet) in
            if tweet != nil {
                self?.tweet = tweet
            }
        }
    }
    
    
    private func refreshReply() {
        
    }
}
