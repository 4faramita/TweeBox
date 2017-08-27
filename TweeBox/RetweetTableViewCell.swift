//
//  RetweetTableViewCell.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/18.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit
import Kingfisher
import DateToolsSwift
import SnapKit


class RetweetTableViewCell: TweetWithTextTableViewCell {
    
    
    @IBOutlet weak var originTweetView: OriginTweetView!
    
    @IBAction func originTweetTapped(byReactingTo: UIGestureRecognizer) {
        guard let section = section, let row = row else { return }
        delegate?.originTweetTapped(section: section, row: row)
    }
        
    override func updateUI() {
        
        super.updateUI()
        
        addTapGesture()
        
        originTweetView.originTweet = tweet?.quotedStatus
        
    }
    
    private func addTapGesture() {
        let tapOnOriginTweet = UITapGestureRecognizer(
            target: self,
            action: #selector(originTweetTapped(byReactingTo:))
        )
        tapOnOriginTweet.numberOfTapsRequired = 1
        tapOnOriginTweet.numberOfTouchesRequired = 1
        originTweetView.addGestureRecognizer(tapOnOriginTweet)
    }

}
