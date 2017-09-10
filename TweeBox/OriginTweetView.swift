//
//  OriginTweetView.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/19.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

class OriginTweetView: UIView {

    public var originTweet: Tweet! {
        didSet {
            setOriginTweet()
        }
    }
    
    private var thumbImages: [TweetMedia]? {
        return originTweet.tweetEntities?.thumbMedia
    }
    
    private var hasMedia: Bool {
        return (thumbImages != nil && thumbImages!.count > 0)
    }
    
    private func setOriginTweet() {
        
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        if hasMedia {
            print(">>> has media >> \(originTweet.text)")
            self.snp.makeConstraints({ (make) in
                make.height.equalTo(150)
            })
        }
        
        
        var thumbImageView: UIImageView?
        
        let upperBorder = UIButton()
        addSubview(upperBorder)
        upperBorder.backgroundColor = .lightGray
        upperBorder.alpha = 0.5
        upperBorder.isUserInteractionEnabled = false
        upperBorder.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.8)
            make.height.equalTo(1)
            make.centerX.equalTo(self)
        }
        
        let lowerBorder = UIButton()
        addSubview(lowerBorder)
        lowerBorder.backgroundColor = .lightGray
        lowerBorder.alpha = 0.5
        lowerBorder.isUserInteractionEnabled = false
        lowerBorder.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.8)
            make.height.equalTo(1)
            make.centerX.equalTo(self)
        }
        
        if hasMedia {
            
            thumbImageView = UIImageView()
            addSubview(thumbImageView!)
            thumbImageView?.snp.makeConstraints { (make) in
                make.trailing.equalTo(self)
                make.top.equalTo(self)
                make.height.equalTo(150)
                make.width.equalTo(150)
            }
            thumbImageView!.kf.setImage(with: thumbImages?[0].mediaURL)
        }
        
        let profileImageView = UIImageView()
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(8)
            make.leading.equalTo(upperBorder).offset(-16)
            make.height.equalTo(32)
            make.width.equalTo(32)
        }
        profileImageView.cutToRound(radius: 16)
        profileImageView.kf.setImage(with: originTweet?.user?.profileImageURL?.url)
        
        let originNameLabel = UILabel()
        addSubview(originNameLabel)
        originNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
            if hasMedia {
                make.trailing.greaterThanOrEqualTo(thumbImageView!.snp.leading).offset(-5)
            } else {
                make.trailing.greaterThanOrEqualTo(self)
            }
        }
        originNameLabel.text = originTweet.user?.name
        originNameLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        originNameLabel.lineBreakMode = .byTruncatingTail
        
        let originScreenNameLabel = UILabel()
        addSubview(originScreenNameLabel)
        originScreenNameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
            if hasMedia {
                make.trailing.greaterThanOrEqualTo(thumbImageView!.snp.leading).offset(-5)
            } else {
                make.trailing.greaterThanOrEqualTo(self)
            }
        }
        originScreenNameLabel.text = "@\(originTweet.user?.screenName)"
        originScreenNameLabel.textColor = .darkGray
        originScreenNameLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        originScreenNameLabel.lineBreakMode = .byTruncatingTail
        
        let originTextLabel = UILabel()
        addSubview(originTextLabel)
        originTextLabel.text = originTweet.text
        originTextLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        originTextLabel.lineBreakMode = .byTruncatingTail
        originTextLabel.numberOfLines = 0
        originTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(3)
            make.leading.equalTo(upperBorder)
            make.bottom.equalTo(self).offset(-5)
            if hasMedia {
                make.trailing.equalTo(thumbImageView!.snp.leading).offset(-5)
            } else {
                make.trailing.equalTo(upperBorder)
            }
        }
    }

}
