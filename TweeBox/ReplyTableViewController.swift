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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tweetInfoContainerView?.frame.size.height = 10
        tweetInfoContainerView.sizeToFit()
        print(tweetInfoContainerView.frame)
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
