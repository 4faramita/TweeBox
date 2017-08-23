//
//  SingleTweetViewController.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/21.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit
import Kanna
import SafariServices

class SingleTweetViewController: UIViewController {
    
    private var retweet: Tweet?
    
    private var clientLink: String?
    
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
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        view.sizeToFit()
//    }
    
    private func setTweetContent() {
        
        if (tweet.entities?.realMedia == nil) || (tweet.entities?.realMedia!.count == 0) {
            containerView.removeFromSuperview()
        } else {
//            childViewControllers[0].view.isUserInteractionEnabled = true
        }
        
        profileImageView.kf.setImage(with: tweet.user.profileImageURL)
        profileImageView.cutToRound(radius: nil)
        
        nameLabel.text = tweet.user.name
        screenNameLabel.text = "@\(tweet.user.screenName)"
        textContentLabel.attributedText = TwitterAttributedContent(tweet).attributedString
        
        let clientHTMLString = tweet.source
        if let doc = HTML(html: clientHTMLString, encoding: .utf8) {
            for link in doc.css("a, link") {
                let attributedString = NSMutableAttributedString(string: (link.text ?? ""))
                
                let range = NSRange.init(location: 0, length: attributedString.length)
                
                attributedString.addAttribute(NSLinkAttributeName, value: (link["href"] ?? ""), range: range)
                clientLink = link["href"]
                
                let font = UIFont.preferredFont(forTextStyle: .caption2)
                attributedString.addAttribute(NSFontAttributeName, value: font, range: range)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: range)
                clientButton.setAttributedTitle(attributedString, for: .normal)
                
                clientButton.addTarget(self, action: #selector(clickOnClient(_:)), for: .touchUpInside)
            }
        }
        
        
        if let date = tweet.createdTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone.current
            let dateString = dateFormatter.string(from: date)
            
            createdTimeLabel.text = dateString
        }
        
        likeCountLabel.text = "\((tweet.favoriteCount ?? 0).shortExpression) like"
        
        retweetCountButton.setTitle("\(tweet.retweetCount.shortExpression) retweet", for: .normal)
    }
    
    
    @IBAction private func clickOnClient(_ sender: Any?) {
        if let url = URL(string: clientLink ?? "") {
            let safariViewController = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            present(safariViewController, animated: true)
        }
    }
    
    
    private func setTweet() {
        SingleTweet(
            tweetParams: TweetParams(of: tweetID!),
            resourceURL: ResourceURL.statuses_show_id
        ).fetchData { [weak self] (tweet) in
            if tweet != nil {
                self?.tweet = tweet
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            switch identifier {
            case "Retweet List":
                if let userListViewController = segue.destination as? UserListTableViewController {
                    
                    let retweetIDListRetriever = RetweeterID(
                        resourceURL: ResourceURL.statuses_retweeters_ids,
                        retweetersIDParams: RetweetersIDParams(id: tweetID, cursor: nil),
                        fetchOlder: nil,
                        nextCursor: nil,
                        previousCursor: nil
                    )
                    retweetIDListRetriever.fetchData({ (nextCursor, previousCursor, idList) in
                        print(">>> idList >> \(idList)")
                        userListViewController.resourceURL = ResourceURL.user_lookup
                        userListViewController.userListParams = MultiUserParams(userID: idList, screenName: nil)
                        userListViewController.previousCursor = previousCursor
                        userListViewController.nextCursor = nextCursor
                    })
                }
                
            case "Media Container":
                print(">>> container segue")
                if let imageContainerViewController = segue.destination as? ImageContainerViewController {
                    print(">>> container segue >> true")
                    imageContainerViewController.tweet = tweet
                }

            default:
                return
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Media Container" {
            return (tweet.entities?.realMedia != nil)
        }
            
        // FIX THIS
        if identifier == "Retweet List" {
            return false
        }
        return true
    }
    
    
    private func refreshReply() {
        
    }
}


