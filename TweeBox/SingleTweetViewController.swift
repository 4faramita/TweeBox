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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isUserInteractionEnabled = true
    }

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var textContentLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var clientButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
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
        
        containerView.isUserInteractionEnabled = true
        
        profileImageView.kf.setImage(with: tweet.user.profileImageURL)
        profileImageView.cutToRound(radius: nil)
        
        nameLabel.text = tweet.user.name
        screenNameLabel.text = "@\(tweet.user.screenName)"
        textContentLabel.attributedText = TwitterAttributedContent(tweet).attributedString
        
        createdTimeLabel.text = tweet.createdTime?.description
        clientButton.titleLabel?.text = tweet.source
        likeCountLabel.text = "\((tweet.favoriteCount ?? 0).shortExpression) like"
        retweetCountButton.titleLabel?.text = "\(tweet.retweetCount.shortExpression) retweet"
    }
    
    
    private func setTweet() {
        SingleTweet(tweetParams: TweetParams(of: tweetID!), resourceURL: ResourceURL.statuses_show_id).fetchData { [weak self] (tweet) in
            if tweet != nil {
                self?.tweet = tweet
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Media Container" {
            if let imageContainerViewController = segue.destination as? ImageContainerViewController {
                imageContainerViewController.tweet = tweet
            }
        }
    }
    
    
    private func refreshReply() {
        
    }
}
