//
//  UserTimelineTableViewController.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/10.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit
import TwitterKit
import Kingfisher
import MXParallaxHeader
import VisualEffectView
import YYText
import SwipeCellKit


class UserTimelineTableViewController: TimelineTableViewController {

    public var user: TwitterUser? {
        didSet {
            if userID == nil {
                userID = user?.id
            }
            addHeader()
        }
    }

    public var userID: String? {
        didSet {
            if user == nil {
                setUser()
            }
        }
    }


    private var profileImage: UIImage?
    private var profileImageURL: URL?

    private var profileBannerImage: UIImage?
    private var profileBannerImageURL: URL?

    private let headerView = UIImageView()
    private var visualEffectView: VisualEffectView?
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let screenNameLabel = UILabel()
    private let bioLabel = YYLabel()
    private var locationLabel: UILabel?
    private var userURLButton: UIButton?
    private let folllowerButton = UIButton()
    private let folllowingButton = UIButton()

    private var objects = [UIView?]()

    private var headerHeight: CGFloat = 0
    private var headerHeightCalculated = false

    private var isStretching = false {
        didSet {
            if !isStretching, isRefreshing {
                isRefreshing = false
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let height = tableView.parallaxHeader.view?.bounds.height {

            if headerHeightCalculated {
                
                if height > (headerHeight * 1.1) {
                    isStretching = true
                } else {
                    isStretching = false
                }
            
                pullToRefresh(height)
            }

            makeProfileObjectsDisapearByPulling(height)

            if height <= Constants.profileToolbarHeight {
                navigationItem.title = user?.name
            } else {
                navigationItem.title = ""
            }
        }

        if !headerHeightCalculated {
            calculateHeaderHeight()
        }
    }
    
    override func initRefreshIfNeeded() {
        if timeline.flatMap({ $0 }).count == 0 {
//            showEmptyWarningMessage()
//            tableView.es_startPullToRefresh()
            refreshTimeline(handler: nil)
        }

    }
    
    override func addRefresher() { }

    private func pullToRefresh(_ height: CGFloat) {
        if height > (headerHeight + Constants.profilePanelDragOffset) {
            refreshTimeline(handler: nil)
        }
    }

    private func setUser() {
        SingleUser(
            params: UserParams(userID: userID, screenName: nil),
            resourceURL: ResourceURL.user_show
        ).fetchData { [weak self] (singleUser) in
            if singleUser != nil {
                self?.user = singleUser!
            }
        }
    }

    private func makeProfileObjectsDisapearByPulling(_ height: CGFloat) {

        objects = [profileImageView, nameLabel, screenNameLabel, bioLabel, locationLabel, userURLButton]

        visualEffectView?.blurRadius = min(10 * max(0, (headerHeight + Constants.profilePanelDragOffset - height) / Constants.profilePanelDragOffset), 10)
        visualEffectView?.colorTintAlpha = min(0.5 * max(0, (headerHeight + Constants.profilePanelDragOffset - height) / Constants.profilePanelDragOffset), 0.5)

        for object in objects {
            if let object = object {
                object.alpha = min(max(0, (headerHeight + Constants.profilePanelDragOffset - height) / Constants.profilePanelDragOffset), 1)
            }
        }
    }

    private func calculateHeaderHeight() {

        if let userURLButton = userURLButton {
            let convertedBounds = headerView.convert(userURLButton.bounds, from: userURLButton)
            headerHeight = convertedBounds.maxY
        } else if let locationLabel = locationLabel {
            let convertedBounds = headerView.convert(locationLabel.bounds, from: locationLabel)
            headerHeight = convertedBounds.maxY
        } else {
            let bioConvertedBounds = headerView.convert(bioLabel.bounds, from: bioLabel)
            let imageConvertedBounds = headerView.convert(profileImageView.bounds, from: profileImageView)
            headerHeight = max(bioConvertedBounds.maxY, imageConvertedBounds.maxY)
        }

        if headerHeight > (Constants.profileToolbarHeight + Constants.contentUnifiedOffset) {

            headerHeight = max(headerHeight, CGFloat(2 * Constants.profileImageRadius + Constants.contentUnifiedOffset))
            headerHeight += (Constants.profileToolbarHeight + Constants.contentUnifiedOffset)
            tableView.parallaxHeader.height = headerHeight
            headerHeightCalculated = true
        }
    }
    
    override func refreshTimeline(handler: ((Void) -> Void)?) {
        
        if !isRefreshing {
            
            isRefreshing = true
            
            let userTimelineParams = UserTimelineParams(of: userID!)
            
            let timeline = Timeline(
                maxID: maxID,
                sinceID: sinceID,
                fetchNewer: fetchNewer,
                resourceURL: userTimelineParams.resourceURL,
                params: userTimelineParams
            )
            
            timeline.fetchData { [weak self] (maxID, sinceID, tweets) in
                
                if (self?.maxID == nil) && (self?.sinceID == nil) {
                    if let sinceID = sinceID {
                        self?.sinceID = sinceID
                    }
                    if let maxID = maxID {
                        self?.maxID = maxID
                    }
                } else {
                    if (self?.fetchNewer)! {
                        if let sinceID = sinceID {
                            self?.sinceID = sinceID
                        }
                    } else {
                        if let maxID = maxID {
                            self?.maxID = maxID
                        }
                    }
                    
                }
                
                if tweets.count != 0 {
                    self?.insertNewTweets(with: tweets)
                }
                
                if !((self?.isStretching)!) {
                    self?.isStretching = false
                }
                
                if let handler = handler {
                    handler()
                }
            }
        }
    }

    override func profileImageTapped(section: Int, row: Int) {

        let destinationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController")

        let segue = UIStoryboardSegue(identifier: "profileImageTapped", source: self, destination: destinationViewController) {
            self.navigationController?.show(destinationViewController, sender: self)
        }

        clickedTweet = timeline[section][row]
        if let originTweet = clickedTweet?.retweetedStatus, let retweetText = clickedTweet?.text, retweetText.hasPrefix("RT @") {
            clickedTweet = originTweet
        }

        self.prepare(for: segue, sender: self)
        segue.perform()
    }

//    override func showEmptyWarningMessage() {
//        emptyWarningCollapsed = true
//    }
    
    @IBAction func done(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Logout", message: "You are logging out the current account. Proceed?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [weak self] (action) in
            Twitter.sharedInstance().sessionStore.logOutUserID(Constants.selfID)
            self?.performSegue(withIdentifier: "Login", sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

    // Header
    private func addHeader() {

        headerView.isUserInteractionEnabled = true
        headerView.kf.setImage(with: user?.profileBannerURL?.url, placeholder: nil, options: nil, progressBlock: nil) { [weak self] (image, error, cacheType, url) in
            self?.profileBannerImage = image
            self?.profileBannerImageURL = url
        }

        let tapOnBanner = UITapGestureRecognizer(target: self, action: #selector(tapToViewBannerImage(_:)))
        tapOnBanner.numberOfTapsRequired = 1
        tapOnBanner.numberOfTouchesRequired = 1
        headerView.addGestureRecognizer(tapOnBanner)

        visualEffectView = VisualEffectView(frame: view.bounds)
        visualEffectView?.blurRadius = 10
        visualEffectView?.colorTint = .black
        visualEffectView?.colorTintAlpha = 0.5
        headerView.addSubview(visualEffectView!)


        headerView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerView).offset(-25)
            make.left.equalTo(headerView).offset(Constants.contentUnifiedOffset)
            make.width.equalTo(Constants.profileImageRadius * 2)
            make.height.equalTo(Constants.profileImageRadius * 2)
        }
        profileImageView.kf.setImage(with: user?.profileImageURL?.url, placeholder: nil, options: nil, progressBlock: nil) { [weak self] (image, error, cacheType, url) in
            self?.profileImage = image
            self?.profileImageURL = url
        }

        profileImageView.layer.borderWidth = 3.0
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.cutToRound(radius: Constants.profileImageRadius)
        profileImageView.isUserInteractionEnabled = true
        profileImageView.isOpaque = false

        let tapOnHead = UITapGestureRecognizer(target: self, action: #selector(tapToViewProfileImage(_:)))
        tapOnHead.numberOfTapsRequired = 1
        tapOnHead.numberOfTouchesRequired = 1
        profileImageView.addGestureRecognizer(tapOnHead)


        headerView.addSubview(nameLabel)
        nameLabel.text = user?.name
        nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headerView).offset(Constants.contentUnifiedOffset + (Constants.profileImageRadius * 2) + 10)
            make.top.equalTo(headerView).offset(Constants.contentUnifiedOffset)
        }
        nameLabel.isOpaque = false


        headerView.addSubview(screenNameLabel)
        screenNameLabel.text = "@\(user?.screenName ?? "twitterUser")"
        screenNameLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        screenNameLabel.textColor = .lightGray
        screenNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headerView).offset(Constants.contentUnifiedOffset + (Constants.profileImageRadius * 2) + 9)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
        }
        screenNameLabel.isOpaque = false


        headerView.addSubview(bioLabel)
        if let user = user {
            bioLabel.attributedText = TwitterAttributedContent(user).attributedString
        }
        bioLabel.lineBreakMode = .byWordWrapping
        bioLabel.numberOfLines = 0

        bioLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headerView).offset(Constants.contentUnifiedOffset + (Constants.profileImageRadius * 2) + 10)
            make.right.equalTo(headerView).offset(-Constants.contentUnifiedOffset)
            make.top.equalTo(screenNameLabel.snp.bottom).offset(8)
        }
        bioLabel.isOpaque = false


        if let location = user?.location, location != "" {
            locationLabel = UILabel()
            headerView.addSubview(locationLabel!)
            locationLabel?.text = location
            locationLabel?.font = UIFont.preferredFont(forTextStyle: .caption2)
            locationLabel?.textColor = .lightGray
            locationLabel?.snp.makeConstraints { (make) in
                make.left.equalTo(headerView).offset(Constants.contentUnifiedOffset + (Constants.profileImageRadius * 2) + 9)
                make.top.equalTo(bioLabel.snp.bottom).offset(6)
            }
            locationLabel?.isOpaque = false
        }

        if let userURL = user?.url {
            userURLButton = UIButton()
            headerView.addSubview(userURLButton!)
            userURLButton?.snp.makeConstraints { (make) in
                make.left.equalTo(headerView).offset(Constants.contentUnifiedOffset + (Constants.profileImageRadius * 2) + 9)
                if let location = user?.location, location != "" {
                    make.top.equalTo(locationLabel!.snp.bottom).offset(5)
                } else {
                    make.top.equalTo(bioLabel.snp.bottom).offset(5)
                }
            }
            userURLButton?.setTitle(userURL, for: .normal)
            userURLButton?.setTitleColor(.lightGray, for: .normal)
            //            userURLButton.titleLabel?.textAlignment = .center
//            userURLButton?.titleLabel?.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .caption2), size: 12)
            userURLButton?.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption2)
            //            userURLButton(forAction: #selector(tapFollowerButton(_:)), withSender: self)

        }


        let toolbar = UIToolbar()
        headerView.addSubview(toolbar)
        toolbar.snp.makeConstraints { (make) in
            make.bottom.equalTo(headerView)
            make.height.equalTo(50)
            make.width.equalTo(headerView)
        }
        toolbar.barStyle = .default


        toolbar.addSubview(folllowerButton)
        folllowerButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(toolbar)
            make.leading.equalTo(toolbar)
            make.width.equalTo(toolbar).multipliedBy(0.5)
            make.height.equalTo(toolbar)
        }
        folllowerButton.setTitle("\(user?.followersCount ?? 0) follower", for: .normal)
        folllowerButton.setTitleColor(.darkGray, for: .normal)
        folllowerButton.titleLabel?.textAlignment = .center
//        folllowerButton.titleLabel?.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .caption2), size: 14)
        folllowerButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        folllowerButton.addTarget(self, action: #selector(viewFollowerList(_:)), for: .touchUpInside)


        toolbar.addSubview(folllowingButton)
        folllowingButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(toolbar)
            make.trailing.equalTo(toolbar)
            make.width.equalTo(toolbar).multipliedBy(0.5)
            make.height.equalTo(toolbar)
        }
        folllowingButton.setTitle("\(user?.followingCount ?? 0) following", for: .normal)
        folllowingButton.setTitleColor(.darkGray, for: .normal)
        folllowingButton.titleLabel?.textAlignment = .center
        folllowingButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        folllowingButton.addTarget(self, action: #selector(viewFollowingList(_:)), for: .touchUpInside)

        let separator = UIButton()
        toolbar.addSubview(separator)
        separator.snp.makeConstraints { (make) in
            make.center.equalTo(toolbar)
            make.width.equalTo(1)
            make.height.equalTo(toolbar).multipliedBy(0.6)
        }
        separator.backgroundColor = .gray
        separator.isUserInteractionEnabled = false


        headerView.contentMode = .scaleAspectFill
        tableView.parallaxHeader.height = 200
        tableView.parallaxHeader.view = headerView
        tableView.parallaxHeader.mode = .fill
        tableView.parallaxHeader.minimumHeight = Constants.profileToolbarHeight

    }

    @IBAction private func viewFollowerList(_ sender: Any?) {
        performSegue(withIdentifier: "User List", sender: folllowerButton)
    }

    @IBAction private func viewFollowingList(_ sender: Any?) {
        performSegue(withIdentifier: "User List", sender: folllowingButton)
    }

    @IBAction private func tapToViewBannerImage(_ sender: UIGestureRecognizer) {
        imageURLToShare = profileBannerImageURL
        clickMedia = profileBannerImage
    }

    @IBAction private func tapToViewProfileImage(_ sender: UIGestureRecognizer) {
        print(">>> profileImage tapped")
        imageURLToShare = profileImageURL
        clickMedia = profileImage
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "User List" {
            
            if let sender = sender as? UIButton, let userListTableViewController = segue.destination.content as? UserListTableViewController {
                
                if let realViewController = segue.destination as? UserListTableViewController {
                    realViewController.navigationItem.rightBarButtonItem = nil
                }
                
                var userListRetriever: UserList? = nil
                
                if (sender.titleLabel?.text?.hasSuffix("follower") ?? false) {
                    
                    userListRetriever = UserList(
                        resourceURL: ResourceURL.followers_list,
                        params: UserListParams(userID: userID!),
                        fetchOlder: nil, nextCursor: nil, previousCursor: nil,
                        headID: nil,
                        tailID: nil
                    )
                } else if (sender.titleLabel?.text?.hasSuffix("following") ?? false) {
                    
                    userListRetriever = UserList(
                        resourceURL: ResourceURL.followings_list,
                        params: UserListParams(userID: userID!),
                        fetchOlder: nil, nextCursor: nil, previousCursor: nil,
                        headID: nil,
                        tailID: nil
                    )

                }
                userListTableViewController.userListRetriever = userListRetriever
            }
        }

        super.prepare(for: segue, sender: sender)
    }
}


extension UserTimelineTableViewController {
    override func addLeftActions(at indexPath: IndexPath) -> [SwipeAction]? {
        if userID == Constants.selfID {
            let tweet = timeline[indexPath.section][indexPath.row]
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
                print(">>> Delete")
                
                let alert = UIAlertController(title: "About To Delete", message: "This tweet will be destoryed forever. Proceed?", preferredStyle: .alert)
                alert.addAction(
                    UIAlertAction(
                        title: "OK",
                        style: .destructive,
                        handler: { (action) in
                            
                            guard let id = tweet.id else { return }
                            
                            let composer = SimpleTweetComposer(id: id)
                            composer.deleteTweet() { [weak self] (succeeded, _) in
                                
                                self?.timeline[indexPath.section].remove(at: indexPath.row)
                                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                                // SwipeCellKit already did the tableview update for .destructive
                                
//                                if succeeded {
//                                    print(">>> Delete succeed")
//                                } else {
//                                    print(">>> Delete failed")
//                                }
                            }
                        }
                    )
                )
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
            deleteAction.image = UIImage(named: "delete")
            deleteAction.textColor = .black
            
            return [deleteAction]
        } else {
            return nil
        }
    }
    
    
    override func addRightActions(at indexPath: IndexPath) -> [SwipeAction]? {
        
        let tweet = timeline[indexPath.section][indexPath.row]
        
        let replyAction = SwipeAction(style: .default, title: "Reply") { [weak self] action, indexPath in
            print(">>> Reply")
            
            self?.performSegue(withIdentifier: "Compose", sender: tweet)
        }
        replyAction.image = UIImage(named: "reply_true")
        replyAction.textColor = .darkGray
        
        let retweetAction: SwipeAction
        if tweet.retweeted {
            retweetAction = SwipeAction(style: .default, title: "Undo Retweet") { action, indexPath in
                print(">>> Undo Retweet")
                
                guard let id = tweet.id else { return }
                
                let composer = SimpleTweetComposer(id: id)
                composer.unRetweet() { [weak self] (succeeded, returnTweet) in
                    
                    if let originTweet = tweet.retweetedStatus,
                        let returnTweet = returnTweet,
                        originTweet.id == returnTweet.id {
                        
//                        if originTweet.user.id == Constants.selfID {
                        returnTweet.retweeted = false
                        self?.timeline[indexPath.section][indexPath.row] = returnTweet
                        self?.tableView.reloadRows(at: [indexPath], with: .automatic)
//                        } else {
//                            self?.timeline[indexPath.section].remove(at: indexPath.row)
//                            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
//                        }
                        
                    } else {
                        print(">>> Undo Retweet failed")
                    }
                    
                }
            }
            retweetAction.image = UIImage(named: "retweet_false")
        } else {
            retweetAction = SwipeAction(style: .default, title: "Retweet") { action, indexPath in
                print(">>> Retweet")
                
                guard let id = tweet.id else { return }
                
                let composer = SimpleTweetComposer(id: id)
                composer.retweet() { [weak self] (succeeded, retweet) in
                    
                    if let retweet = retweet {
                        retweet.retweeted = true
                        if let originTweet = retweet.retweetedStatus {
                            originTweet.retweeted = true
                        }
                        self?.timeline[indexPath.section][indexPath.row] = retweet
                        self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                    if succeeded {
                        print(">>> Retweet succeed")
                    } else {
                        print(">>> Retweet failed")
                    }
                }
                
            }
            retweetAction.image = UIImage(named: "retweet_true")
        }
        retweetAction.backgroundColor = .orange
        retweetAction.textColor = .darkGray
        
        let likeAction: SwipeAction
        if tweet.favorited {
            likeAction = SwipeAction(style: .default, title: "Me No Likey") { action, indexPath in
                print(">>> Dislike")
                
                guard let id = tweet.id else { return }
                
                let composer = SimpleTweetComposer(id: id)
                composer.dislike() { [weak self] (succeeded, tweet) in
                    
                    if succeeded {
                        print(">>> Dislike succeed")
                        if let tweet = tweet {
                            tweet.favorited = false
                            self?.timeline[indexPath.section][indexPath.row] = tweet
                            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    } else {
                        print(">>> Dislike failed")
                    }
                }
                
            }
            likeAction.image = UIImage(named: "like_false")
            
        } else {
            likeAction = SwipeAction(style: .default, title: "Like") { action, indexPath in
                print(">>> Like")
                
                guard let id = tweet.id else { return }
                
                let composer = SimpleTweetComposer(id: id)
                composer.like() { [weak self] (succeeded, tweet) in
                    
                    if succeeded {
                        print(">>> Like succeed")
                        if let tweet = tweet {
                            tweet.favorited = true
                            self?.timeline[indexPath.section][indexPath.row] = tweet
                            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    } else {
                        print(">>> Like failed")
                    }
                }
            }
            likeAction.image = UIImage(named: "like_true")
        }
        
        likeAction.backgroundColor = .yellow
        likeAction.textColor = .darkGray
        
        return [likeAction, retweetAction, replyAction]
    }
}
