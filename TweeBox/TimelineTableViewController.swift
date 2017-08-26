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

class TimelineTableViewController: UITableViewController
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
    weak var delegate:TweetWithPicTableViewCell?

//    var clickedCellTextLabelHeight: CGFloat?
    var clickedTweet: Tweet?
    var clickedImageIndex: Int?
    var clickMedia: UIImage? {
        didSet {
            performSegue(withIdentifier: "imageTapped", sender: self)
        }
    }
    var imageURLToShare: URL?

    var media: [TweetMedia]!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.refreshControl?.endRefreshing()
    }
    
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
    
    
    private func updateTimeLabel() {
        let cells = self.tableView.visibleCells
        for cell in cells {
            if let tweetCell = cell as? TweetTableViewCell {
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
        self.timeline.insert(newTweets, at: 0)
        self.tableView.insertSections([0], with: .automatic)
    }
    
    
    func refreshTimeline() {
        
        let homeTimelineParams = HomeTimelineParams()
        
        let timeline = Timeline(
            maxID: maxID,
            sinceID: sinceID,
            fetchNewer: fetchNewer,
            resourceURL: homeTimelineParams.resourceURL,
            timelineParams: homeTimelineParams
        )
        
        timeline.fetchData { [weak self] (maxID, sinceID, tweets) in
            if let maxID = maxID {
                self?.maxID = maxID
            }
            if let sinceID = sinceID {
                self?.sinceID = sinceID
            }
//                self?.tableView.reloadData()
            
            if tweets.count > 0 {
                
                self?.insertNewTweets(with: tweets)
                
                let cells = self?.tableView.visibleCells
                if cells != nil {
                    for cell in cells! {
                        let indexPath = self?.tableView.indexPath(for: cell)
                        if let tweetCell = cell as? TweetTableViewCell {
                            tweetCell.section = indexPath?.section
                        }
                    }
                    
                }
                
            }
            
            Timer.scheduledTimer(
                withTimeInterval: TimeInterval(0.1),
                repeats: false) { (timer) in
                    self?.refreshControl?.endRefreshing()
            }
        }
        
    }
    
    @IBAction func search(_ sender: UIBarButtonItem) {
        
        let searchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GeneralSearchViewController")
        let popup = PopupDialog.init(viewController: searchViewController)
        
//        let popup = PopupDialog(title: "Test Dialog", message: "Look!", image: UIImage(named: "twitter_selected"))
//        let buttonOne = CancelButton(title: "CANCEL") {
//            print("You canceled the car dialog.")
//        }
//        
//        let buttonTwo = DefaultButton(title: "ADMIRE CAR") {
//            print("What a beauty!")
//        }
//        
//        let buttonThree = DefaultButton(title: "BUY CAR", height: 60) {
//            print("Ah, maybe next time :)")
//        }
//        
//        popup.addButtons([buttonOne, buttonTwo, buttonThree])

        present(popup, animated: true, completion: nil)
    }
    
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        refreshTimeline()
    }
    
    @objc private func tapToPresentMediaViewer(byReactingTo tapGesture: UITapGestureRecognizer) {
        performSegue(withIdentifier: "To Media", sender: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        clickedTweet = timeline[indexPath.section][indexPath.row]
        
//        if let cell = tableView.cellForRow(at: indexPath) as? TweetWithTextTableViewCell {
//            clickedCellTextLabelHeight = cell.tweetTextContent?.frame.height
//        } else if let cell = tableView.cellForRow(at: indexPath) as? TweetWithPicAndTextTableViewCell {
//            clickedCellTextLabelHeight = cell.tweetTextContent?.frame.height
//        }

        setAndPerformSegue()
    }

    func setAndPerformSegue() {
        performSegue(withIdentifier: "View Tweet", sender: self)
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
            cell = tableView.dequeueReusableCell(withIdentifier: "Retweet with Comment", for: indexPath)
            if let retweetCell = cell as? RetweetTableViewCell {
                retweetCell.tweet = tweet
                
                // tap to segue
                retweetCell.delegate = self
                retweetCell.section = indexPath.section
                retweetCell.row = indexPath.row
            }
            
        } else if let media = tweet.entities?.media {
            switch media.count {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: "Tweet with Text", for: indexPath)
                if let tweetCell = cell as? TweetWithTextTableViewCell {
                    tweetCell.tweet = tweet
                    
                    // tap to segue
                    tweetCell.delegate = self
                    tweetCell.section = indexPath.section
                    tweetCell.row = indexPath.row
                }
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: "Tweet with Pic and Text", for: indexPath)
                if let tweetCell = cell as? TweetWithPicAndTextTableViewCell {
                    tweetCell.tweet = tweet
                    
                    // tap to segue
                    tweetCell.delegate = self
                    tweetCell.section = indexPath.section
                    tweetCell.row = indexPath.row
                    tweetCell.mediaIndex = 0
                }
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: "Tweet with Two Pics and Text", for: indexPath)
                if let tweetCell = cell as? TweetWithPicAndTextTableViewCell {
                    tweetCell.tweet = tweet
                    
                    // tap to segue
                    tweetCell.delegate = self
                    tweetCell.section = indexPath.section
                    tweetCell.row = indexPath.row
                }
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: "Tweet with Three Pics and Text", for: indexPath)
                if let tweetCell = cell as? TweetWithPicAndTextTableViewCell {
                    tweetCell.tweet = tweet
                    
                    // tap to segue
                    tweetCell.delegate = self
                    tweetCell.section = indexPath.section
                    tweetCell.row = indexPath.row
                }
            case 4:
                cell = tableView.dequeueReusableCell(withIdentifier: "Tweet with Four Pics and Text", for: indexPath)
                if let tweetCell = cell as? TweetWithPicAndTextTableViewCell {
                    tweetCell.tweet = tweet
                    
                    // tap to segue
                    tweetCell.delegate = self
                    tweetCell.section = indexPath.section
                    tweetCell.row = indexPath.row
                }
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: "Tweet with Text", for: indexPath)
                if let tweetCell = cell as? TweetWithTextTableViewCell {
                    tweetCell.tweet = tweet
                    
                    // tap to segue
                    tweetCell.delegate = self
                    tweetCell.section = indexPath.section
                    tweetCell.row = indexPath.row
                }
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "Tweet with Text", for: indexPath)
            if let tweetCell = cell as? TweetWithTextTableViewCell {
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
extension TimelineTableViewController: TweetTableViewCellProtocol {
    
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
                    
                    if let realViewController = segue.destination as? UserTimelineTableViewController {
                        realViewController.navigationItem.rightBarButtonItem = nil
                    }

                    
                    profileViewController.user = clickedTweet?.user
                }
                
            case "View Tweet":
                if let singleTweetViewController = segue.destination.content as? ReplyTableViewController {
                    singleTweetViewController.tweet = clickedTweet
                }
            default:
                break
            }
        }
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
//                        self?.performSegue(withIdentifier: "imageTapped", sender: nil)
                    }
                }
                
            }

        }
    }
}
