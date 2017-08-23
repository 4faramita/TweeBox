//
//  ReplyTableViewController.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/23.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit

class ReplyTableViewController: MentionTimelineTableViewController {

    @IBOutlet weak var tweetInfoContainerView: UIView!
    
    public var tweet: Tweet?    
    public var tweetID: String?
    public var cellTextLabelHeight: CGFloat?
    private var hasMedia: Bool {
        if let media = tweet?.entities?.realMedia, media.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        for subview in (tweetInfoContainerView.subviews[0].subviews) {
            if subview.frame.height > 0, subview.subviews.count != 0 {
                tweetInfoContainerView?.frame.size.height = subview.frame.height + CGFloat(10)
            }
        }
//        tweetInfoContainerView.removeConstraints(tweetInfoContainerView.constraints)
//        tweetInfoContainerView?.frame.size.height = CGFloat(10 + 48 + 10)
//
//        if let textLabelHeight = cellTextLabelHeight, textLabelHeight != 0 {
//            tweetInfoContainerView?.frame.size.height += (textLabelHeight + CGFloat(10))
//        }
//
//        if hasMedia {
//            tweetInfoContainerView?.frame.size.height += CGFloat(211 + 8)
//        }
//
//        tweetInfoContainerView?.frame.size.height += CGFloat(28 + 8)
    //        tweetInfoContainerView.sizeToFit()
    //        print(tweetInfoContainerView.frame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshTimeline()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Single Tweet Info" {
            if let singleTweetViewController = segue.destination.content as? SingleTweetViewController {
                singleTweetViewController.tweet = tweet
            }
        }
    }
}
