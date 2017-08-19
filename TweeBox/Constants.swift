//
//  Constants.swift
//  TweeBox
//
//  Created by 4faramita on 2017/7/28.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit

struct Constants {
    
    static let selfID = Twitter.sharedInstance().sessionStore.session()?.userID ?? "-1"

    static let tweetLimitPerRefresh = "50"
    static let userLimitPerRefresh = "50"
    
    static let picQuality = MediaSize.large
    
    static let aspectRatioWidth: CGFloat = 16
    static let aspectRatioHeight: CGFloat = 9
    
    static let normalAspect = aspectRatioHeight / aspectRatioWidth
    static let thinAspect = normalAspect * 2
    
    static let picCornerRadius: CGFloat = 3

    static let defaultProfileRadius = ProfileRadius.round.rawValue
    
    static let picFadeInDuration = 0.2
    
    static let naturalReading = true
    
    static let profileImageRadius: CGFloat = 50
    static let profilePanelDragOffset: CGFloat = 100
    static let profileToolbarHeight: CGFloat = 50
    static let contentUnifiedOffset: CGFloat = 20
    
}

enum ProfileRadius: CGFloat {
    case round = 200
    case square = 20
}
