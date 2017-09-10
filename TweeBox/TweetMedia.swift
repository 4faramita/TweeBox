//
//  TweetMedia.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/7.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON

class TweetMedia: TweetEntity {
    
//    public var id: String  // id_str
    
//    public var mediaURLHTTP: URL?  // media_url
//    public var mediaURL: URL?  // media_url_https
//    public var url: URL?
    // The media URL that was extracted
//    public var displayURL: String
    // Not a URL but a string to display instead of the media URL
//    public var expandedURL: URL?
    // The fully resolved media URL
    
    public var sizes: TweetPhotoSize
    /*
     We support different sizes: thumb, small, medium and large.
     The media_url defaults to medium but you can retrieve the media in different sizes by appending a colon + the size key
     (for example: http://pbs.twimg.com/media/A7EiDWcCYAAZT1D.jpg:thumb ).
     Each available size comes with three attributes that describe it:
     w : the width (in pixels) of the media in this particular size;
     h : the height (in pixels) of the media in this particular size;
     and resize : how we resized the media to this particular size (can be crop or fit )
     */
    
//    public var type: String
    
//    public var extAltText: String?
    
//    public var sourceStatusID: String?
    // For Tweets containing media that was originally associated with a different tweet,
    // this string-based ID points to the original Tweet.
    
    // only for video
    public var videoInfo: TweetVideoInfo?
    
    
    init(with json: JSON, quality: MediaSize) {
        
        id = json["id_str"].stringValue
        mediaURLHTTP = URL(string: json["media_url"].stringValue, quality: quality)?.absoluteString
        mediaURL = URL(string: json["media_url_https"].stringValue, quality: quality)?.absoluteString
        url = URL(string: json["url"].stringValue)?.absoluteString
        displayURL = json["display_url"].stringValue
        expandedURL = URL(string: json["expanded_url"].stringValue)?.absoluteString
        sizes = TweetPhotoSize(with: json["sizes"])
        type = json["type"].stringValue
        extAltText = json["ext_alt_text"].string
        sourceStatusID = json["source_status_id_str"].string
        
        if json["video_info"].null == nil {
            // video exists
            videoInfo = TweetVideoInfo(with: json["video_info"])
        }
        
        super.init(with: json)
    }
}

extension TweetMedia {
    
    func getCutSize(with ratio: CGFloat, at quality: MediaSize) -> CGSize {
        
        let picWidth: CGFloat
        let picHeight: CGFloat
        
        let actualSize: TweetPhotoSize.sizeObject
        
        
        switch quality {
        case .thumb:
            actualSize = self.sizes.thumb
        case .small:
            actualSize = self.sizes.small
        case .medium:
            actualSize = self.sizes.medium
        case .large:
            actualSize = self.sizes.large
        default:
            actualSize = self.sizes.large
        }
        let actualHeight = CGFloat(actualSize.h)
        let actualWidth = CGFloat(actualSize.w)
        
        if  actualHeight / actualWidth >= ratio {
            // too long
            picWidth = actualWidth
            picHeight = picWidth * ratio
        } else {
            // too wide
            picHeight = actualHeight
            picWidth = picHeight / ratio
        }
        
        return CGSize(width: picWidth, height: picHeight)
    }
}
