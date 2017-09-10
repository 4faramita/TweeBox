//
//  TweetMediaContainerView.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/27.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class TweetMediaContainerView: UIView {

    public var tweet: Tweet? {
        didSet {
            if isQuote {
                setQuote()
            } else {
                setLayout()
            }
        }
    }
    
    var isQuote: Bool {
        return (tweet?.quotedStatus != nil)
    }
    
    var quoted: Tweet? {
        if isQuote {
            return tweet?.quotedStatus
        } else {
            return nil
        }
    }
    
    private var media: [TweetMedia]? {
        return tweet?.entities?.media?.allObjects as? [TweetMedia]
    }
    
//    private var clickedIndex = 0
//    private var images = [UIImage]()
    private var imageViews = [UIImageView]()
    
    private let placeholder = UIImage(named: "picPlaceholder")!
    private let cutPoint = CGPoint(x: 0.5, y: 0.5)

    
    private func setQuote() {
        
    }
    
    
    private func setLayout() {
        
        if let media = media {
            switch media.count {
            case 1:
                let firstImageView = addImageView(at: 0)
                
                firstImageView.snp.makeConstraints({ (make) in
                    make.size.equalTo(self)
                    make.center.equalTo(self)
                })
                
            case 2:
                let firstImageView = addImageView(at: 0)
                firstImageView.snp.makeConstraints({ (make) in
                    make.width.equalTo(self).multipliedBy(0.5)
                    make.height.equalTo(self)
                    make.top.equalTo(self)
                    make.leading.equalTo(self)
                })
                
                let secondImageView = addImageView(at: 1)
                secondImageView.snp.makeConstraints({ (make) in
                    make.size.equalTo(firstImageView)
                    make.top.equalTo(firstImageView)
                    make.trailing.equalTo(self)
                })
                
            case 3:
                let firstImageView = addImageView(at: 0)
                firstImageView.snp.makeConstraints({ (make) in
                    make.width.equalTo(self).multipliedBy(0.5)
                    make.height.equalTo(self)
                    make.top.equalTo(self)
                    make.leading.equalTo(self)
                })
                
                let secondImageView = addImageView(at: 1)
                secondImageView.snp.makeConstraints({ (make) in
                    make.width.equalTo(firstImageView)
                    make.height.equalTo(firstImageView).multipliedBy(0.5)
                    make.top.equalTo(firstImageView)
                    make.trailing.equalTo(self)
                })
                
                let thirdImageView = addImageView(at: 2)
                thirdImageView.snp.makeConstraints({ (make) in
                    make.size.equalTo(secondImageView)
                    make.bottom.equalTo(firstImageView)
                    make.trailing.equalTo(self)
                })
                
            case 4:
                let firstImageView = addImageView(at: 0)
                firstImageView.snp.makeConstraints({ (make) in
                    make.width.equalTo(self).multipliedBy(0.5)
                    make.height.equalTo(self).multipliedBy(0.5)
                    make.top.equalTo(self)
                    make.leading.equalTo(self)
                })
                
                let secondImageView = addImageView(at: 1)
                secondImageView.snp.makeConstraints({ (make) in
                    make.size.equalTo(firstImageView)
                    make.top.equalTo(firstImageView)
                    make.trailing.equalTo(self)
                })
                
                let thirdImageView = addImageView(at: 2)
                thirdImageView.snp.makeConstraints({ (make) in
                    make.size.equalTo(firstImageView)
                    make.bottom.equalTo(self)
                    make.leading.equalTo(self)
                })
                
                let fourthImageView = addImageView(at: 3)
                fourthImageView.snp.makeConstraints({ (make) in
                    make.size.equalTo(firstImageView)
                    make.bottom.equalTo(self)
                    make.trailing.equalTo(self)
                })
                
            default:
                break
            }
        }
    }
    
    
    private func addImageView(at index: Int) -> UIImageView {
        
        let imageView = UIImageView()
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        
        var ratio: CGFloat {
            let total = media!.count
            if (total == 2) || (total == 3 && index == 0) {
                return Constants.thinAspectRatio
            } else {
                return Constants.normalAspectRatio
            }
        }
        
        
        let cutSize = media![index].getCutSize(with: ratio, at: .small)
        let processor = CroppingImageProcessor(size: cutSize, anchor: cutPoint)
        
//        KingfisherManager.shared.retrieveImage(with: media![index].mediaURL!, options: nil, progressBlock: nil) { [weak self] (image, error, cacheType, url) in
//            
//            if let image = image, let cutPoint = self?.cutPoint {
//                self?.images.append(image)
//                let cuttedImage = image.kf.crop(to: cutSize, anchorOn: cutPoint)
//                imageView.image = cuttedImage
//            }
//        }
        
        imageView.kf.setImage(
            with: media![index].mediaURL?.url,
            placeholder: placeholder,
            options: [
                .transition(.fade(Constants.picFadeInDuration)),
                .processor(processor)
            ]
        )
        
        imageView.isUserInteractionEnabled = true
        
        // add tap gesture
        let gestures = [#selector(tapOnFirstImage(_:)), #selector(tapOnSecondImage(_:)), #selector(tapOnThirdImage(_:)), #selector(tapOnFourthImage(_:))]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: gestures[index])
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tapGesture)
        
        imageViews.append(imageView)
        
        return imageView
    }
    
    
    @IBAction private func tapOnFirstImage(_ sender: UIGestureRecognizer) {
        if let tweetCell = self.superview?.superview?.superview?.superview as? GeneralTweetTableViewCell {
            tweetCell.mediaIndex = 0
            print(">>> 1st tapped")
        }
    }
    @IBAction private func tapOnSecondImage(_ sender: UIGestureRecognizer) {
        if let tweetCell = self.superview?.superview?.superview?.superview as? GeneralTweetTableViewCell {
            tweetCell.mediaIndex = 1
            print(">>> 2nd tapped")

        }
    }
    @IBAction private func tapOnThirdImage(_ sender: UIGestureRecognizer) {
        if let tweetCell = self.superview?.superview?.superview?.superview as? GeneralTweetTableViewCell {
            tweetCell.mediaIndex = 2
            print(">>> 3rd tapped")

        }
    }
    @IBAction private func tapOnFourthImage(_ sender: UIGestureRecognizer) {
        if let tweetCell = self.superview?.superview?.superview?.superview as? GeneralTweetTableViewCell {
            tweetCell.mediaIndex = 3
            print(">>> 4th tapped")

        }
    }
}
