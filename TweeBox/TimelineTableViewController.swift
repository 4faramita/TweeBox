//
//  TimelineTableViewController.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/6.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit
//import AMScrollingNavbar
import Kingfisher
//import Whisper
import SnapKit
import PopupDialog
import ESPullToRefresh

class TimelineTableViewController: UITableViewController, TweetClickableContentProtocol
//, ScrollingNavigationControllerDelegate 
{
    var emptyWarningCollapsed = false

    var timeline = [Array<Tweet>]() {
        didSet {
            
            guard timeline.count > 0, emptyWarningCollapsed else {
                
                if timeline.count > 0
//                    , let navigationController = navigationController
                {
//                    Whisper.hide(whisperFrom: navigationController)
                    tableView.separatorStyle = .singleLine
                    emptyWarningCollapsed = true
                }
                return
            }
            
            print(">>> Batch >> \(timeline.count)")
        }
    }
    
    public var maxID: String?
    public var sinceID: String?
    public var fetchNewer = true
    /*
     if there is a newer batch, there exists a maxID;
     if there is a older batch, there exists a sinceID.
     
     if last panning gesture is upward, fetchNewer is true;
     if last panning gesture is downward, fetchNewer is false.
     */
    
    // tap to segue
    weak var delegate:GeneralTweetTableViewCell?

    var clickedTweet: Tweet? {
        didSet {
            fetchedUser = clickedTweet?.user
        }
    }
    var clickedImageIndex: Int?
    var clickMedia: UIImage? {
        didSet {
            performSegue(withIdentifier: "imageTapped", sender: self)
        }
    }
    var imageURLToShare: URL?

    var media: [TweetMedia]!
    
    var keyword: String? {
        didSet {
            if let newKeyword = keyword, newKeyword.hasPrefix("@") || newKeyword.hasPrefix("#") {
                let index = newKeyword.index(newKeyword.startIndex, offsetBy: 1)
                keyword = newKeyword.substring(from: index)
            }
        }
    }
    
    var fetchedUser: TwitterUser?

    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addRefresher()
        pullToLoaderMore()
        
        //  Warning text when table is empty
        
        if timeline.flatMap({ $0 }).count == 0 {
            showEmptyWarningMessage()
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            self?.updateTimeLabel()
        })
        
//        hideBarsOnScrolling()
    }
    
    // Hide bars on scrolling
//    func hideBarsOnScrolling() {
//        if let navigationController = navigationController as? ScrollingNavigationController, let tabBarController = tabBarController {
//            navigationController.followScrollView(
//                tableView,
//                delay: 50.0,
//                scrollSpeedFactor: (Constants.naturalReading ? -1 : 1),
//                followers: [tabBarController.tabBar]
//            )
//        }
//
//    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        self.refreshControl?.endRefreshing()
//    }
    
    // Hide bars on scrolling
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
    
//        stopHiddingbard()
//    }
    
//    func stopHiddingbard() {
//        if let navigationController = navigationController as? ScrollingNavigationController {
//            navigationController.stopFollowingScrollView()
//        }
//        
//    }
    
    func addRefresher() {
        self.tableView.es_addPullToRefresh {
            [unowned self] in
            
            self.fetchNewer = true
            self.refreshTimeline {
                //                self.tableView.es_stopPullToRefresh(ignoreDate: true)
                self.tableView.es_stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
            }
            
            /// 设置ignoreFooter来处理不需要显示footer的情况
//            self.tableView.es_stopPullToRefresh(completion: true, ignoreFooter: false)
        }
    }
    
    func pullToLoaderMore() {
        self.tableView.es_addInfiniteScrolling {
            [weak self] in
            self?.fetchNewer = false
            self?.refreshTimeline {
                self?.tableView.es_stopLoadingMore()
            }
            /// 如果你的加载更多事件成功，调用es_stopLoadingMore()重置footer状态
//            self.tableView.es_stopLoadingMore()
            /// 通过es_noticeNoMoreData()设置footer暂无数据状态
//            self.tableView.es_noticeNoMoreData()
        }
    }
    
    func alertForNoSuchUser(viewController: UIViewController) {
        
        print(">>> no user")
        
        let popup = PopupDialog(title: "Cannot Find User @\(keyword ?? "")", message: "Please check your input.", image: nil)
        let cancelButton = CancelButton(title: "OK") { }
        popup.addButton(cancelButton)
        viewController.present(popup, animated: true, completion: nil)
        
    }
    
    
    private func updateTimeLabel() {
        let cells = self.tableView.visibleCells
        for cell in cells {
            if let tweetCell = cell as? GeneralTweetTableViewCell {
                tweetCell.tweetCreatedTime.text = tweetCell.tweet?.createdTime?.shortTimeAgoSinceNow
            }
        }
    }
    
    
    func showEmptyWarningMessage() {
//        let message = Message(title: "Pull down to refresh.", backgroundColor: .orange)
        tableView.separatorStyle = .none
//        if let navigationController = navigationController {
//            Whisper.show(whisper: message, to: navigationController, action: .present)
//        }
    }
    
    
    func insertNewTweets(with newTweets: [Tweet]) {
        if fetchNewer {
            self.timeline.insert(newTweets, at: 0)
            self.tableView.insertSections([0], with: .automatic)
        } else {
            self.timeline.append(newTweets)
            self.tableView.insertSections([self.timeline.endIndex - 1], with: .automatic)
        }
    }
    
    
    func refreshTimeline(handler: ((Void) -> Void)?) {
        
        let homeTimelineParams = HomeTimelineParams()
        
        let timeline = Timeline(
            maxID: maxID,
            sinceID: sinceID,
            fetchNewer: fetchNewer,
            resourceURL: homeTimelineParams.resourceURL,
            timelineParams: homeTimelineParams
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
            
            if tweets.count > 0 {
                
                self?.insertNewTweets(with: tweets)
                
                let cells = self?.tableView.visibleCells
                if cells != nil {
                    for cell in cells! {
                        let indexPath = self?.tableView.indexPath(for: cell)
                        if let tweetCell = cell as? GeneralTweetTableViewCell {
                            tweetCell.section = indexPath?.section
                        }
                    }
                    
                }
                
            }
            if let handler = handler {
                handler()
            }
        }
        
    }
    
    @IBAction func search(_ sender: UIBarButtonItem) {
        
        let searchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GeneralSearchViewController")
        let popup = PopupDialog.init(viewController: searchViewController)
        
        present(popup, animated: true, completion: nil)
    }
    
    
//    @IBAction func refresh(_ sender: UIRefreshControl) {
//        refreshTimeline()
//    }
    
    @objc private func tapToPresentMediaViewer(byReactingTo tapGesture: UITapGestureRecognizer) {
        performSegue(withIdentifier: "To Media", sender: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        clickedTweet = timeline[indexPath.section][indexPath.row]
        
        setAndPerformSegueForSingleTweet()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return timeline.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeline[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        let tweet = timeline[indexPath.section][indexPath.row]
        
        if (tweet.quotedStatus != nil) || (tweet.retweetedStatus?.quotedStatus != nil) {
            cell = tableView.dequeueReusableCell(withIdentifier: "Quote Tweet", for: indexPath)
            if let retweetCell = cell as? GeneralTweetTableViewCell {
                
                retweetCell.tweet = tweet
                
                // tap to segue
                retweetCell.delegate = self
                retweetCell.section = indexPath.section
                retweetCell.row = indexPath.row
            }
        } else if let count = tweet.entities?.media?.count, count > 0 {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "Tweet with Media", for: indexPath)
            
            if let tweetCell = cell as? GeneralTweetTableViewCell {
                
                tweetCell.tweet = tweet
                
                // tap to segue
                tweetCell.delegate = self
                tweetCell.section = indexPath.section
                tweetCell.row = indexPath.row
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
            
            if let tweetCell = cell as? GeneralTweetTableViewCell {
                
                tweetCell.tweet = tweet
                
                // tap to segue
                tweetCell.delegate = self
                tweetCell.section = indexPath.section
                tweetCell.row = indexPath.row
            }
        }

        return cell
    }
    
    // Hide bars on scrolling
//    override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
//        if let navigationController = navigationController as? ScrollingNavigationController {
//            navigationController.showNavbar(animated: true)
//        }
//        return true
//    }
}

// tap to segue
extension TimelineTableViewController: GeneralTweetTableViewCellProtocol {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            
            switch identifier {
                
            case "imageTapped":
                if let imageViewer = segue.destination.content as? ImageViewerViewController {
                    imageViewer.image = clickMedia
                    imageViewer.imageURL = imageURLToShare
                }
            case "videoTapped":
                if let videoViewer = segue.destination.content as? VideoViewerViewController {
                    videoViewer.tweetMedia = media[0]
                }
            case "profileImageTapped":
                if let profileViewController = segue.destination.content as? UserTimelineTableViewController {
                    
//                    if let realViewController = segue.destination as? UserTimelineTableViewController {
                    profileViewController.navigationItem.rightBarButtonItem = nil
//                    }
                    

                    profileViewController.user = fetchedUser
//                    profileViewController.user = clickedTweet?.user
                }
                
            case "View Tweet":
                if let singleTweetViewController = segue.destination.content as? ReplyTableViewController {
                    singleTweetViewController.tweet = clickedTweet
                }
                
            case "Show Tweets with Hashtag":
                if let searchTimelineViewController = segue.destination.content as? SearchTimelineTableViewController,
                    let keyword = keyword {
                    searchTimelineViewController.query = "%23\(keyword)"
                    searchTimelineViewController.navigationItem.title = "#\(keyword)"
                    
                    searchTimelineViewController.navigationItem.rightBarButtonItem = nil
                }
                
            case "Show User":
                if let profileViewController = segue.destination.content as? UserTimelineTableViewController {
                    if let user = fetchedUser {
                        profileViewController.user = user
                        profileViewController.navigationItem.rightBarButtonItem = nil
                    }
                }

            default:
                break
            }
        }
    }
    
    func setAndPerformSegueForHashtag() {
        performSegue(withIdentifier: "Show Tweets with Hashtag", sender: self)
    }
    
    func setAndPerformSegueForSingleTweet() {
        performSegue(withIdentifier: "View Tweet", sender: self)
    }


    
    func profileImageTapped(section: Int, row: Int) {
                
        clickedTweet = timeline[section][row]
        if let originTweet = clickedTweet?.retweetedStatus, let retweetText = clickedTweet?.text, retweetText.hasPrefix("RT @") {
            clickedTweet = originTweet
        }
        
        performSegue(withIdentifier: "profileImageTapped", sender: nil)
    }
    
    func originTweetTapped(section: Int, row: Int) {
        clickedTweet = timeline[section][row]
        if let originTweet = clickedTweet?.quotedStatus {
            clickedTweet = originTweet
            performSegue(withIdentifier: "View Tweet", sender: nil)
        }
    }

    
    func imageTapped(section: Int, row: Int, mediaIndex: Int, media: [TweetMedia]) {
        
        self.clickedTweet = timeline[section][row]
        self.clickedImageIndex = mediaIndex
        self.media = media
        self.imageURLToShare = clickedTweet?.entities?.mediaToShare?[clickedImageIndex ?? 0].mediaURL
        
        if media.count == 1, media[0].type != "photo" {
            performSegue(withIdentifier: "videoTapped", sender: nil)
        } else {
            if let clickedMediaURL = clickedTweet?.entities?.realMedia?[clickedImageIndex ?? 0].mediaURL {
                
                let progressView = UIProgressView(progressViewStyle: .bar)
                progressView.alpha = 0
                progressView.backgroundColor = .gray
                progressView.progressTintColor = .orange
                
                if let navigationView = navigationController?.view {
                    navigationView.addSubview(progressView)
                    if progressView.alpha == 0 {
                        UIView.animate(
                            withDuration: 0.5,
                            delay: 0,
                            options: [.curveLinear],
                            animations: { progressView.alpha = 0.5 },
                            completion: nil
                        )
                    }
                    progressView.snp.makeConstraints({ (make) in
                        make.size.equalTo(UIApplication.shared.statusBarFrame.size)
                    })
                }
                
                KingfisherManager.shared.retrieveImage(with: clickedMediaURL, options: nil, progressBlock: {
                    receivedSize, totalSize in
                    let percentage = (Float(receivedSize) / Float(totalSize))  // * 100.0
                    
                    progressView.setProgress(percentage, animated: true)
                    
//                    let tapToStopLoading = UITapGestureRecognizer(target: self, action: #selector("stopLoading(_:)"))
//                    tapToStopLoading.numberOfTapsRequired = 1
//                    tapToStopLoading.numberOfTouchesRequired = 1
//                    progressView.addGestureRecognizer(progressView)
//                    
//                    func stopLoading(_ sender: UIGestureRecognizer) { }
                    
                }) { [weak self] (image, error, cacheType, url) in
                    if progressView.alpha > 0 {
                        UIView.animate(
                            withDuration: 0.5,
                            delay: 0,
                            options: [.curveLinear],
                            animations: { progressView.alpha = 0 },
                            completion: { if $0 { progressView.removeFromSuperview() } }
                        )
                    }
                    
                    if let image = image {
                        self?.clickMedia = image
                    }
                }
                
            }

        }
    }
}
