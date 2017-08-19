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
        
    override func updateUI() {
        
        super.updateUI()
        
        originTweetView.originTweet = tweet?.quotedStatus
        
    }
}
