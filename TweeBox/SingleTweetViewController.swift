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
import VisualEffectView
import YYText
import PopupDialog

class SingleTweetViewController: UIViewController, TweetClickableContentProtocol {
    
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
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var textContentLabel: YYLabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var clientButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var retweetCountButton: UIButton!
    
    
    var keyword: String? {
        didSet {
            if let newKeyword = keyword, newKeyword.hasPrefix("@") || newKeyword.hasPrefix("#") {
                let index = newKeyword.index(newKeyword.startIndex, offsetBy: 1)
                keyword = newKeyword.substring(from: index)
            }
        }
    }
    
    var fetchedUser: TwitterUser?
    
    func alertForNoSuchUser(viewController: UIViewController) {
        
        print(">>> no user")
        
        let popup = PopupDialog(title: "Cannot Find User @\(keyword ?? "")", message: "Please check your input.", image: nil)
        let cancelButton = CancelButton(title: "OK") { }
        popup.addButton(cancelButton)
        viewController.present(popup, animated: true, completion: nil)
        
    }

    func setAndPerformSegueForHashtag() {
        performSegue(withIdentifier: "Show Tweets with Hashtag", sender: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if tweet != nil {
            setTweetContent()
        }
        
        if tweetID != nil {
            refreshReply()
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
    
    @IBAction private func tapOnProfileImage(_ sender: UIGestureRecognizer) {
        
        fetchedUser = tweet.user
        performSegue(withIdentifier: "profileImageTapped", sender: sender)
    }
    
    private func setTweetContent() {
        
        if (tweet.entities?.realMedia == nil) || (tweet.entities?.realMedia!.count == 0) {
            containerView.removeFromSuperview()
        } else if let media = tweet.entities?.realMedia, media.count == 1 {
            if media[0].type != "photo" {
                addPlayLabel(to: containerView, isGif: (media[0].type == "animated_gif"))
            }
        }
        containerView.cutToRound(radius: 5)
        
        profileImageView.kf.setImage(with: tweet.user.profileImageURL)
        profileImageView.cutToRound(radius: nil)
        profileImageView.isUserInteractionEnabled = true
        
        let tapProfile = UITapGestureRecognizer(target: self, action: #selector(tapOnProfileImage(_:)))
        tapProfile.numberOfTapsRequired = 1
        tapProfile.numberOfTouchesRequired = 1
        profileImageView.addGestureRecognizer(tapProfile)
        
        nameLabel.text = tweet.user.name
        screenNameLabel.text = "@\(tweet.user.screenName)"
        
        textContentLabel.attributedText = TwitterAttributedContent(tweet).attributedString
        textContentLabel.lineBreakMode = .byWordWrapping
        textContentLabel.numberOfLines = 0
        textContentLabel.textAlignment = .natural
        textContentLabel.preferredMaxLayoutWidth = containerView.bounds.width
        textContentLabel.font = UIFont.preferredFont(forTextStyle: .body)

        print(">>> label >> \(textContentLabel.subviews)")
        
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
            params: TweetParams(of: tweetID!),
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
//            case "Retweet List":
//                if let userListViewController = segue.destination as? UserListTableViewController {
//                    
//                    let retweetIDListRetriever = RetweeterID(
//                        resourceURL: ResourceURL.statuses_retweeters_ids,
//                        retweetersIDParams: RetweetersIDParams(id: tweetID, cursor: nil),
//                        fetchOlder: nil,
//                        nextCursor: nil,
//                        previousCursor: nil
//                    )
//                    retweetIDListRetriever.fetchData({ (nextCursor, previousCursor, idList) in
//                        print(">>> idList >> \(idList)")
//                        userListViewController.resourceURL = ResourceURL.user_lookup
//                        userListViewController.userListParams = MultiUserParams(userID: idList, screenName: nil)
//                        userListViewController.previousCursor = previousCursor
//                        userListViewController.nextCursor = nextCursor
//                    })
//                }
                
            case "Media Container":
                if let imageContainerViewController = segue.destination as? ImageContainerViewController {
                    imageContainerViewController.tweet = tweet
                }
                
            case "profileImageTapped":
                
                if let profileViewController = segue.destination.content as? UserTimelineTableViewController {
                    if let user = fetchedUser {
                        profileViewController.user = user
                        profileViewController.navigationItem.rightBarButtonItem = nil
                    }
                }

                
            case "Show Tweets with Hashtag":
                if let searchTimelineViewController = segue.destination.content as? SearchTimelineTableViewController,
                    let keyword = keyword {
                    searchTimelineViewController.query = "%23\(keyword)"
                    searchTimelineViewController.navigationItem.title = "#\(keyword)"
                    
                    searchTimelineViewController.navigationItem.rightBarButtonItem = nil
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


