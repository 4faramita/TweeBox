//
// Created by 4faramita on 2017/8/24.
// Copyright (c) 2017 4faramita. All rights reserved.
//

import Foundation
import UIKit


class SearchTimelineTableViewController: TimelineTableViewController {

    var query: String? {
        didSet {
            refreshTimeline()
        }
    }

    var resultType: SearchResultType {
        return .recent
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    override func setAndPerformSegueForHashtag() {
        
        let destinationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchTimelineViewController")
        
        let segue = UIStoryboardSegue(identifier: "Show Tweets with Hashtag", source: self, destination: destinationViewController) {
            self.navigationController?.show(destinationViewController, sender: self)
        }
        
        self.prepare(for: segue, sender: self)
        segue.perform()

    }
    

    override func refreshTimeline() {

        let replyTimelineParams = SearchTweetParams(
                query: self.query ?? "",
                resultType: self.resultType,
                until: nil,
                sinceID: nil,  // this two will be managed
                maxID: nil,    // in timeline data retriever
                includeEntities: true,
                resourceURL: ResourceURL.search_tweets
        )

        let searchTimeline = SearchTimeline(
                maxID: maxID,
                sinceID: sinceID,
                fetchNewer: fetchNewer,
                resourceURL: replyTimelineParams.resourceURL,
                timelineParams: replyTimelineParams
        )

        searchTimeline.fetchData { [weak self] (maxID, sinceID, tweets) in

            if let maxID = maxID {
                self?.maxID = maxID
            }
            if let sinceID = sinceID {
                self?.sinceID = sinceID
            }
            
            print(">>> tweets >> \(tweets.count)")

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
}
