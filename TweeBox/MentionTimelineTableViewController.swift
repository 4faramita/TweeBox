//
//  MentionTimelineTableViewController.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/23.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit

class MentionTimelineTableViewController: TimelineTableViewController {

    override func refreshTimeline(handler: ((Void) -> Void)?) {
        
        let mentionTimelineParams = MentionTimelineParams()
        
        let timeline = Timeline(
            maxID: maxID,
            sinceID: sinceID,
            fetchNewer: fetchNewer,
            resourceURL: mentionTimelineParams.resourceURL,
            params: mentionTimelineParams
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
}
